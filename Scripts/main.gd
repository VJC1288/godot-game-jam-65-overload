extends Node2D

const PLAYER = preload("res://Scenes/player.tscn")
const PAUSEMENU = preload("res://Scenes/pausemenu.tscn")

@onready var coin_spawner:CoinSpawner = $CoinSpawner
@onready var enemy_spawner = $EnemySpawner
@onready var hud = $HUD
@onready var level_manager = $LevelManager

func _ready():
	randomize()
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	
	spawn_player(centerOfScreen)
	
	enemy_spawner.connect("enemy_killed", enemy_killed)
	coin_spawner.connect("spawner_coin_collected", update_coin_count)
	level_manager.initialize(hud)
	
	coin_spawner.spawn_coins(centerOfScreen + Vector2(50, 50), randi_range(1,5))
	hud.update_coin_count()

func spawn_player(locationToSpawn:Vector2):
	var player = PLAYER.instantiate()
	player.global_position = locationToSpawn
	player.connect("player_health_changed", update_health_bar)
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

func update_health_bar(new_value):
	hud.update_health(new_value)

func update_coin_count(amount):
	Globals.currentCoinCount += amount
	hud.update_coin_count()

func equip_wpn1():
	Globals.currentPlayer.weapon_1.show()
