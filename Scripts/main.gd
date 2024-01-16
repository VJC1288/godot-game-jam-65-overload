extends Node2D

const PLAYER = preload("res://Scenes/player.tscn")
const PAUSEMENU = preload("res://Scenes/pausemenu.tscn")
const GAMEOVER = preload("res://Scenes/gameover.tscn")


@onready var coin_spawner:CoinSpawner = $CoinSpawner
@onready var enemy_spawner = $EnemySpawner
@onready var level_manager = $LevelManager
@onready var key_spawner = $KeySpawner


@onready var hud = $HUD


func _ready():
	randomize()
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	
	spawn_player(centerOfScreen)
	
	enemy_spawner.connect("enemy_killed", enemy_killed)
	coin_spawner.connect("spawner_coin_collected", update_coin_count)
	level_manager.initialize(hud, enemy_spawner, coin_spawner, key_spawner)
	
	coin_spawner.spawn_coins(centerOfScreen + Vector2(50, 50), randi_range(1,5))
	key_spawner.spawn_key(centerOfScreen + Vector2(-50, -50))
	
	hud.update_coin_count()

func spawn_player(locationToSpawn:Vector2):
	var player = PLAYER.instantiate()
	player.global_position = locationToSpawn
	player.connect("player_health_changed", update_health_bar)
	player.player_death.connect(game_over)

	Globals.currentPlayer = player
	add_child(player)

func enemy_killed(location:Vector2, type: String):
	
	var amount
	match type:
		"regular_ghost":
			amount = randi_range(1,2)
		"tank_ghost":
			amount = randi_range(3,5)
		"tall_ghost":
			amount = randi_range(2,3)
		_:
			amount = 1

	coin_spawner.spawn_coins(location, amount)

func update_health_bar(new_value):
	hud.update_health(new_value)

func update_coin_count(amount):
	Globals.currentCoinCount += amount
	hud.update_coin_count()

func equip_wpn1():
	Globals.currentPlayer.weapon_1.show()
	
func game_over():
	add_child(GAMEOVER.instantiate())
	get_tree().paused = true
