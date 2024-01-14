extends Node2D

class_name Coin

signal coin_collected(value)

var player = null

@export var item: InvItem

@onready var sprite_2d = $Sprite2D


var coin_value:int

func _on_area_body_entered(body):
	player = body
	emit_signal("coin_collected", coin_value)
  
	player.collect_item(item)
  
	prints("Coins:",Globals.currentCoinCount)
	queue_free()

func set_texture(passed_texture: Texture2D):
	sprite_2d.texture = passed_texture
