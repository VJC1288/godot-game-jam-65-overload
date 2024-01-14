extends Node2D

signal enemy_killed(type)

const GHOST = preload("res://Scenes/ghost.tscn")
@onready var spawn_point = $SpawnPath/SpawnPoint
@onready var spawn_timer = $SpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if spawn_timer.is_stopped() and Globals.currentPlayer != null:
		spawn_timer.start()
		spawn_ghost()


func spawn_ghost():
	var enemy = GHOST.instantiate()
	spawn_point.progress_ratio = randf_range(0,100)
	enemy.global_position = spawn_point.global_position
	add_child(enemy)
	
	
