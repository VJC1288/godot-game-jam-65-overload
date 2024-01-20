extends Node2D

signal enemy_killed(type, location)

const REGULAR_GHOST = preload("res://Scenes/Ghosts/regularGhost.tscn")
const TANK_GHOST = preload("res://Scenes/Ghosts/tankGhost.tscn")
const TALL_GHOST = preload("res://Scenes/Ghosts/tallGhost.tscn")
const SPEED_GHOST = preload("res://Scenes/Ghosts/speedGhost.tscn")
const WALL_GHOST = preload("res://Scenes/Ghosts/wallGhost.tscn")
const BOSS_HAND = preload("res://Scenes/Ghosts/boss_hand.tscn")
const BOSS_GHOST = preload("res://Scenes/Ghosts/boss_ghost.tscn")


@onready var spawn_point = $SpawnPath/SpawnPoint
@onready var spawn_timer = $SpawnTimer
@onready var enemies = $Enemies

@export var active: bool = false

var spawnsLeft:int = 0
var spawnType:int = 1
var bossIsAlive:bool = false

func _physics_process(_delta):
	if active and (spawnsLeft > 0 or bossIsAlive):
		if spawn_timer.is_stopped() and Globals.currentPlayer != null:
			spawn_timer.start()
			spawn_ghost()
			spawnsLeft -= 1


func spawn_ghost():
	var ghost_type = randi_range(1,100)
	var enemy: Ghost
	if ghost_type >= 80 and spawnType == 4:
		enemy = TANK_GHOST.instantiate()
	elif ghost_type >= 70 and spawnType == 3:
		enemy = SPEED_GHOST.instantiate()
	elif ghost_type >= 45 and spawnType == 2:
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

func spawn_specific_ghost_at_area(location: Vector2, type: String):
	var enemy: Ghost
	

	
	match type:
		"tank_ghost":
			enemy = TANK_GHOST.instantiate()
		"speed_ghost":
			enemy = SPEED_GHOST.instantiate()
		"tall_ghost":
			enemy = TALL_GHOST.instantiate()
		"regular_ghost":
			enemy = REGULAR_GHOST.instantiate()
		"wall_ghost":
			enemy = WALL_GHOST.instantiate()
		"boss_ghost":
			enemy = BOSS_GHOST.instantiate()
		"boss_hand":
			enemy = BOSS_HAND.instantiate()
		_:
			print("Tried to make a poo poo ghost")
			return
	
	
	enemy.global_position = location
	


	enemy.connect("ghost_died", ghost_died)
	enemies.add_child(enemy)
	
	########## Wall Ghost Rotation logic #############
	if enemy.ghost_type == "wall_ghost":
		if enemy.global_position.x > (get_viewport_rect().size.x * 8/10):
			enemy.rotate(deg_to_rad(-90))
			
		elif enemy.global_position.x <= (get_viewport_rect().size.x * 2/10):
			enemy.rotate(deg_to_rad(90))
		else:
			pass
	##################################################
