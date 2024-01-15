extends Node2D

class_name Level

signal change_room(direction)

@export var northExit: bool
@export var southExit: bool
@export var eastExit: bool
@export var westExit: bool
@export var levelCoordinates: Vector2i
@export var hasShopkeeper: bool = false
@export var spawnsEnemies: bool = true


@onready var north_exit_area = $NorthExit
@onready var south_exit_area = $SouthExit
@onready var east_exit_area = $EastExit
@onready var west_exit_area = $WestExit
@onready var north_spawn = $NorthSpawn
@onready var south_spawn = $SouthSpawn
@onready var east_spawn = $EastSpawn
@onready var west_spawn = $WestSpawn

var houseFloor: int = 1

func _ready():
	if !northExit:
		north_exit_area.monitoring = false
	if !southExit:
		south_exit_area.monitoring = false
	if !eastExit:
		east_exit_area.monitoring = false
	if !westExit:
		west_exit_area.monitoring = false


func _on_north_exit_body_entered(_body):
	emit_signal("change_room", Vector2i.UP)

func _on_south_exit_body_entered(_body):
	emit_signal("change_room", Vector2i.DOWN)

func _on_east_exit_body_entered(_body):
	emit_signal("change_room", Vector2i.RIGHT)

func _on_west_exit_body_entered(_body):
	emit_signal("change_room", Vector2i.LEFT)
