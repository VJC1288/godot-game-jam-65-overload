extends Node2D

class_name Pickup

signal item_collected
signal upgrade_collected

@onready var sprite_2d = $Sprite2D

@export var item: InvItem
@export var upgrade: InvUpg

var player = null

func _on_area_body_entered(_body):
	player = Globals.currentPlayer
	var amount = 1
	if item != null:
		player.collect_item(item, amount)
		item_collected.emit()
		print("item picked up")
	if upgrade != null:
		player.collect_upgrade(upgrade, amount)
		upgrade_collected.emit()
		Globals.lastPickup = str(upgrade.name)
		print("upgrade picked up")
	queue_free()
