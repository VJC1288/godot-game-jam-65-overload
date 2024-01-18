extends Node2D

class_name Level

signal change_room(direction)

enum DifficultyStates {REGULAR = 1, TALL, TANK}

@export var northExit: bool
@export var southExit: bool
@export var eastExit: bool
@export var westExit: bool
@export var levelCoordinates: Vector2i
@export var hasShopkeeper: bool = false
@export var numberOfEnemySpawns: int = 0
@export var difficulty: DifficultyStates

@onready var north_exit_area = $NorthExit
@onready var south_exit_area = $SouthExit
@onready var east_exit_area = $EastExit
@onready var west_exit_area = $WestExit
@onready var north_spawn = $NorthSpawn
@onready var south_spawn = $SouthSpawn
@onready var east_spawn = $EastSpawn
@onready var west_spawn = $WestSpawn

var houseFloor: int = 1

func _on_north_exit_body_entered(_body):
	emit_signal("change_room", Vector2i.UP)
	print("entered north")
	#north_exit_area.queue_free()
		
func _on_south_exit_body_entered(_body):
	emit_signal("change_room", Vector2i.DOWN)
	print("entered south")
	#south_exit_area.queue_free()
	
func _on_east_exit_body_entered(_body):
	emit_signal("change_room", Vector2i.RIGHT)
	print("entered east")
	#east_exit_area.queue_free()

func _on_west_exit_body_entered(_body):
	emit_signal("change_room", Vector2i.LEFT)
	print("entered west")
	#west_exit_area.queue_free()

func enable_exits():
	if northExit:
		north_exit_area.monitoring = true
	if southExit:
		south_exit_area.monitoring = true
	if eastExit:
		east_exit_area.monitoring = true
	if westExit:
		west_exit_area.monitoring = true
