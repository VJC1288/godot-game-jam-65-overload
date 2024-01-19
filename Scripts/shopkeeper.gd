extends CharacterBody2D


signal item_purchased(type, location, cost)

@onready var shop_area = $ShopArea
@onready var embarrassed_area = $EmbarrassedArea
@onready var sprite_2d = $Sprite2D
@onready var item_1 = $Shop/Item1
@onready var item_2 = $Shop/Item2
@onready var item_3 = $Shop/Item3


@onready var shop = $Shop


const KEY = preload("res://Scenes/Pickups/key.tscn")
const SPECTRE_COAT = preload("res://Scenes/Pickups/spectre_coat.tscn")
const WRAITH_BOOTS = preload("res://Scenes/Pickups/wraith_boots.tscn")
const BEAM_BATTERY_ = preload("res://Scenes/Pickups/beamBattery+.tscn")
const ARC_EXTENDER = preload("res://Scenes/Pickups/arcExtender.tscn")

var shopActive = false
var roomCoords: Vector2i = Vector2i(2,1)
var shopItemSlots:Array = []


func _ready():
	build_shop()
	

func build_shop():
	var inventory = Globals.shopInventory[roomCoords]
	var item_to_add
	var current_item = 0
	shopItemSlots = [item_1, item_2, item_3]
	
	for slot in shopItemSlots:
		slot.connect("item_purchased", purchase_item)
	
	
	for item in inventory:
		var cost = 0
		match item:
			"key":
				item_to_add = KEY.instantiate()
				cost = 5
			"spectre_coat":
				item_to_add = SPECTRE_COAT.instantiate()
				cost = 40
			"beam_battery":
				item_to_add = BEAM_BATTERY_.instantiate()
				cost = 30
			"arc_extender":
				item_to_add = ARC_EXTENDER.instantiate()
				cost = 30
			"wraith_boots":
				item_to_add = WRAITH_BOOTS.instantiate()
				cost = 35
			_:
				item_to_add = null
				
		if item_to_add != null:
			item_to_add.disabled = true
			item_to_add.position.y += 12
			shopItemSlots[current_item].add_child(item_to_add)
			shopItemSlots[current_item].item_name_for_sale = item
			shopItemSlots[current_item].item_for_sale = item_to_add
			shopItemSlots[current_item].set_cost(cost)
		else:
			shopItemSlots[current_item].purchased = true
			shopItemSlots[current_item].visible = false
		current_item += 1

func purchase_item(slot, cost):
	if shopActive == true:
		var inventory = Globals.shopInventory[roomCoords]
		emit_signal("item_purchased", slot.item_name_for_sale, slot.global_position + Vector2(0,15), cost)
		
		match slot:
			item_1:
				inventory[0] = "empty"
			item_2:
				inventory[1] = "empty"
			item_3:
				inventory[2] = "empty"
		
		slot.purchased = true
		slot.visible = false
		slot.item_for_sale.queue_free()
		sprite_2d.region_rect.position.x = 320
		sprite_2d.region_rect.position.y = 224

func _on_embarrassed_area_body_entered(_body):
	sprite_2d.region_rect.position.x = 288
	sprite_2d.region_rect.position.y = 192


func _on_embarrassed_area_body_exited(_body):
	sprite_2d.region_rect.position.x = 320
	sprite_2d.region_rect.position.y = 192


func _on_shop_area_body_entered(_body):
	shop.visible = true
	shopActive = true


func _on_shop_area_body_exited(_body):
	shop.visible = false
	shopActive = false


