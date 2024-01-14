extends CanvasLayer

@onready var weapon_grid = $MarginContainer/PausePanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/WeaponGrid
@onready var item_grid = $MarginContainer/PausePanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/MarginContainer/ItemGrid
@onready var playerWeapons: WpnInv = preload("res://Assets/Inventory/player_weapons.tres")
@onready var playerItems: ItemInv = preload("res://Assets/Inventory/player_items.tres")
@onready var wpn_slots: Array = weapon_grid.get_children()
@onready var item_slots: Array = item_grid.get_children()


func _ready():
	playerItems.updateSlot_sig.connect(update_item_slots)
	update_wpn_slots()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		unpause_game()
	if Input.is_action_just_pressed("quit"):
		quit()

func unpause_game():
		get_tree().paused = false
		queue_free()

func quit():
	get_tree().quit()

func update_wpn_slots():
	for i in range(min(playerWeapons.weapons.size(), wpn_slots.size())):
		wpn_slots[i].update(playerWeapons.weapons[i])
		
func update_item_slots():
	print("updateslot")
	for i in range(min(playerItems.item_slots.size(), item_slots.size())):
		item_slots[i].update(playerItems.item_slots[i])
