extends Node2D

signal enemy_killed(type, location)

const REGULAR_GHOST = preload("res://Scenes/Ghosts/regularGhost.tscn")
const TANK_GHOST = preload("res://Scenes/Ghosts/tankGhost.tscn")
const TALL_GHOST = preload("res://Scenes/Ghosts/tallGhost.tscn")

@onready var spawn_point = $SpawnPath/SpawnPoint
@onready var spawn_timer = $SpawnTimer
@onready var enemies = $Enemies

@export var active: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if active:
		if spawn_timer.is_stopped() and Globals.currentPlayer != null:
			spawn_timer.start()
			spawn_ghost()


func spawn_ghost():
	var ghost_type = randi_range(1,100)
	var enemy: Ghost
	if ghost_type >= 90:
		enemy = TANK_GHOST.instantiate()
	elif ghost_type >= 70:
		enemy = TALL_GHOST.instantiate()
	else:
		enemy = REGULAR_GHOST.instantiate()
	
	spawn_point.progress_ratio = randf_range(0,100)
	enemy.global_position = spawn_point.global_position
	enemy.connect("ghost_died", ghost_died)
	enemies.add_child(enemy)
	
func ghost_died(location, passed_ghost_type):
	emit_signal("enemy_killed", location, passed_ghost_type)

func get_enemies() -> Array[Node]:
	return enemies.get_children()
