extends Node2D

class_name LevelManager

const LEVEL_0_0_ = preload("res://Scenes/Levels/level(0,0).tscn")
const LEVEL_1_0_ = preload("res://Scenes/Levels/level(1,0).tscn")


var current_coords = Vector2i(0,0)
var hud = null

@onready var current_level:Level = $"Level(0,0)"


var levelsDictionary = {
	Vector2i(0,0): LEVEL_0_0_,
	Vector2i(1,0): LEVEL_1_0_
}


func _ready():
	current_level.queue_free()
	var new_level:Level = levelsDictionary[current_coords].instantiate()
	new_level.connect("change_room", switch_level)
	current_level = new_level
	add_child(new_level)

func initialize(passed_hud):
	hud = passed_hud
	

func switch_level(direction: Vector2i):
	Globals.currentPlayer.pause()
	await hud.fade_to_black()	
	current_level.queue_free()
	current_coords += direction
	var new_level:Level = levelsDictionary[current_coords].instantiate()
	new_level.connect("change_room", switch_level)
	current_level = new_level
	add_child(new_level)
	if Globals.currentPlayer != null:
		match direction:
			Vector2i.UP:
				Globals.currentPlayer.global_position = new_level.south_spawn.global_position
			Vector2i.DOWN:
				Globals.currentPlayer.global_position = new_level.north_spawn.global_position
			Vector2i.LEFT:
				Globals.currentPlayer.global_position = new_level.east_spawn.global_position
			Vector2i.RIGHT:
				Globals.currentPlayer.global_position = new_level.west_spawn.global_position
	await hud.unfade_from_black()
	Globals.currentPlayer.unpause()

