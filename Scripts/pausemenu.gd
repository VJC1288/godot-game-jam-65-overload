extends CanvasLayer

@onready var weapon_grid = %WeaponGrid
@onready var upgrade_grid = %UpgradeGrid
@onready var item_grid = %ItemGrid
@onready var playerWeapons: WpnInv = preload("res://Assets/Inventory/player_weapons.tres")
@onready var playerItems: ItemInv = preload("res://Assets/Inventory/player_items.tres")
@onready var playerUpgrades: UpgInv = preload("res://Assets/Inventory/player_upgrades.tres")
@onready var wpn_slots: Array = weapon_grid.get_children()
@onready var upg_slots: Array = upgrade_grid.get_children()
@onready var item_slots: Array = item_grid.get_children()
@onready var menu = $"."
@onready var max_health_value = %MaxHealthValue
@onready var beam_l_value = %BeamLValue
@onready var beam_power_value = %BeamPowerValue



var menu_open: bool = false

func _ready():
	playerItems.updateItemSlot_sig.connect(update_item_slots)
	playerWeapons.updateWpnSlot_sig.connect(update_wpn_slots)
	
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
	update_max_health()
	update_fire_distance()
	update_beam_damage()
	update_wpn_slots()
	update_upg_slots()

func close_menu():
	menu.visible = false
	menu_open = false

func quit():
	get_tree().quit()

func update_wpn_slots():
	for i in range(min(playerWeapons.slots.size(), wpn_slots.size())):
		wpn_slots[i].update(playerWeapons.slots[i])
		
func update_upg_slots():
	for i in range(min(playerUpgrades.slots.size(), item_slots.size())):
		upg_slots[i].update(playerUpgrades.slots[i])
		
func update_item_slots():
	for i in range(min(playerItems.slots.size(), item_slots.size())):
		item_slots[i].update(playerItems.slots[i])
		
func update_max_health():
	max_health_value.text = str(Globals.currentPlayer.health_component.max_health)
	
func update_fire_distance():
	beam_l_value.text = str(Globals.currentPlayer.maxFireDistance)
	
func update_beam_damage():
	beam_power_value.text = str(Globals.currentPlayer.damagePower)
