extends CharacterBody2D

class_name Coin

signal coin_collected(value)

@export var item: InvItem

@onready var sprite_2d = $Sprite2D

var direction: Vector2

var coin_value:int

func _physics_process(_delta):
	if Globals.hasCoinAttractor:
		direction = global_position.direction_to(Globals.currentPlayer.global_position)
		velocity = direction * 10
		move_and_slide()

func _on_area_body_entered(_body):
 
	emit_signal("coin_collected", coin_value)
	var amount = coin_value
	Globals.currentPlayer.collect_item(item, amount)
  
	prints("Coins:",Globals.currentCoinCount)
	queue_free()

func set_texture(passed_texture: Texture2D):
	sprite_2d.texture = passed_texture
