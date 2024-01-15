extends CanvasLayer

@onready var weapon_grid = $MarginContainer/PausePanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/WeaponGrid
@onready var item_grid = $MarginContainer/PausePanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/MarginContainer/ItemGrid
@onready var playerWeapons: WpnInv = preload("res://Assets/Inventory/player_weapons.tres")
@onready var playerItems: ItemInv = preload("res://Assets/Inventory/player_items.tres")
@onready var wpn_slots: Array = weapon_grid.get_children()
@onready var item_slots: Array = item_grid.get_children()
@onready var menu = $"."

var menu_open: bool = false

func _ready():
	playerItems.updateItemSlot_sig.connect(update_item_slots)
	playerWeapons.updateWpnSlot_sig.connect(update_wpn_slots)
	update_wpn_slots()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if menu_open:
			get_tree().paused = false
			close_menu()
		else:
			open_menu()
			get_tree().paused = true
	if Input.is_action_just_pressed("quit") and menu_open:
		quit()

func open_menu():
	menu.visible = true
	menu_open = true

func close_menu():
	menu.visible = false
	menu_open = false

func quit():
	get_tree().quit()

func update_wpn_slots():
	for i in range(min(playerWeapons.slots.size(), wpn_slots.size())):
		wpn_slots[i].update(playerWeapons.slots[i])
		
func update_item_slots():
	for i in range(min(playerItems.slots.size(), item_slots.size())):
		item_slots[i].update(playerItems.slots[i])
