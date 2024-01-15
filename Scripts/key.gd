extends Node2D

class_name Key

signal key_collected

var player = null

@export var item: InvItem

@onready var sprite_2d = $Sprite2D

func _on_area_body_entered(_body):
	player = Globals.currentPlayer
	key_collected.emit()
	var amount = 1
	player.collect_item(item, amount)
	queue_free()
