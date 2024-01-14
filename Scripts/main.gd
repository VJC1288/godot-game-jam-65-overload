extends Node2D

const PLAYER = preload("res://Scenes/player.tscn")
const PAUSEMENU = preload("res://Scenes/pausemenu.tscn")

@onready var coin_spawner:CoinSpawner = $CoinSpawner
@onready var enemy_spawner = $EnemySpawner

func _ready():
	randomize()
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	
	spawn_player(centerOfScreen)
	
	enemy_spawner.connect("enemy_killed", enemy_killed)
		
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

func enemy_killed(type: String, location: Vector2):
	var amount
	match type:
		"regular_ghost":
			amount = randi_range(1,2)
		
		_:
			amount = 1
			
			
	coin_spawner.spawn_coins(location, amount)

func equip_wpn1():
	Globals.currentPlayer.weapon_1.show()
