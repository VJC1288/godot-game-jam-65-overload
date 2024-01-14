extends Node2D

const PLAYER = preload("res://Scenes/player.tscn")
const PAUSEMENU = preload("res://Scenes/pausemenu.tscn")

@onready var coin_spawner = $CoinSpawner
@onready var enemy_spawner = $EnemySpawner

func _ready():
	randomize()
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	
	spawn_player(centerOfScreen)
	coin_spawner.spawn_coins(centerOfScreen + Vector2(50, 50), randi_range(1,5))
	
	
func _process(_delta):
	if Input.is_action_just_pressed("pause") and Globals.paused == false:
		pause_game()
		
func pause_game():
	add_child(PAUSEMENU.instantiate())
	get_tree().paused = true
	
func spawn_player(locationToSpawn:Vector2):
	var player = PLAYER.instantiate()
	player.global_position = locationToSpawn
	Globals.currentPlayer = player
	add_child(player)
	

func equip_wpn1():
	Globals.currentPlayer.weapon_1.show()
