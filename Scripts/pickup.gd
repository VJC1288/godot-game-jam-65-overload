extends Node2D

class_name Pickup

signal item_collected
signal upgrade_collected

@onready var sprite_2d = $Sprite2D
@onready var pickup = $"."

@export var item: InvItem
@export var upgrade: InvUpg
@export var itemName: String
@export var instantItem: bool

var player = null
var disabled = false

func _on_area_body_entered(_body):
	if !disabled:
		player = Globals.currentPlayer
		var amount = 1
		if item != null:
			player.collect_item(item, amount)
			item_collected.emit()
		if upgrade != null:
			player.collect_upgrade(upgrade, amount)
			Globals.lastPickup = upgrade.name
			upgrade_collected.emit()
		if instantItem:
			player.collect_instantItem(itemName)
			Globals.lastPickup = itemName
			item_collected.emit()
				
		queue_free()
