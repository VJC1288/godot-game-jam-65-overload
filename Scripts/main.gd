extends Node2D

const PLAYER = preload("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_player()

func spawn_player():
	var player = PLAYER.instantiate()
	var viewport = get_viewport_rect()
	player.global_position = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	Globals.current_player = player
	add_child(player)
