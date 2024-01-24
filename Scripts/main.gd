extends Node2D

const PLAYER = preload("res://Scenes/player.tscn")
const PAUSEMENU = preload("res://Scenes/pausemenu.tscn")
const GAMEOVER = preload("res://Scenes/gameover.tscn")
const PHOTO = preload("res://Assets/Inventory/photo.tres")

@onready var coin_spawner:CoinSpawner = $CoinSpawner
@onready var enemy_spawner = $EnemySpawner
@onready var level_manager = $LevelManager
@onready var item_spawner = $ItemSpawner
@onready var character_manager = $CharacterManager
@onready var audio_manager = $AudioManager

@onready var hud = $UIElements/HUD

var game_win_flag = false

func _ready():
	randomize()
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2 - 45)
	
	spawn_player(centerOfScreen)
	resetItemInventory()
	resetUpgradeInventory()
	resetWeaponInventory()
	
	enemy_spawner.connect("enemy_killed", enemy_killed)
	enemy_spawner.connect("spawner_boss_died", game_win)
	
	coin_spawner.connect("spawner_coin_collected", update_coin_count)
	
	character_manager.connect("sold_item", item_spawner.spawn_item)
	character_manager.connect("update_coin_count", update_coin_count)
	
	level_manager.initialize(hud, enemy_spawner, coin_spawner, item_spawner, character_manager)
	level_manager.connect("room_spawn_enemy", enemy_spawner.spawn_specific_ghost_at_area)
	level_manager.connect("level_manager_item_spawn", item_spawner.spawn_item)
	level_manager.connect("level_changed", audio_manager.room_change)
	
	item_spawner.initialize(hud)
	
	hud.update_coin_count()
	
	################ Temp Testing Items to Spawn ####################
	#coin_spawner.spawn_coins(centerOfScreen + Vector2(50, 50), randi_range(1,5))
	#item_spawner.spawn_item(centerOfScreen + Vector2(-100, 50), "Key")
	#item_spawner.spawn_item(centerOfScreen + Vector2(-100, 50), "Ghost Buster(Sword)")
	#item_spawner.spawn_item(centerOfScreen + Vector2(-30, -30), "Photo")
	#item_spawner.spawn_item(centerOfScreen + Vector2(50, -50), "Beam Battery")
	#item_spawner.spawn_item(centerOfScreen + Vector2(70, -50), "Beam Battery")
	#item_spawner.spawn_item(centerOfScreen + Vector2(-50, 50), "Arc Extender")
	#item_spawner.spawn_item(centerOfScreen + Vector2(-70, 50), "Arc Extender")
	#item_spawner.spawn_item(centerOfScreen + Vector2(-100, 50), "Wraith Boots")
	#item_spawner.spawn_item(centerOfScreen + Vector2(-100, 30), "Wraith Boots")
	#item_spawner.spawn_item(centerOfScreen + Vector2(-100, -50), "Spectre Coat")
	#item_spawner.spawn_item(centerOfScreen + Vector2(-100, -30), "Spectre Coat")
	#item_spawner.spawn_item(centerOfScreen + Vector2(0, -60), "Geist Goulash")
	##################### Remove on Release #########################


func spawn_player(locationToSpawn:Vector2):
	var player = PLAYER.instantiate()
	player.global_position = locationToSpawn
	player.player_health_changed.connect(update_health_bar)
	player.player_max_health_changed.connect(update_max_health)
	player.player_death.connect(game_over)

	Globals.currentPlayer = player
	character_manager.add_child(player)

func enemy_killed(location:Vector2, type: String):
	
	var amount
	match type:
		"regular_ghost":
			amount = randi_range(1,2)
		"tank_ghost":
			amount = randi_range(3,5)
		"tall_ghost":
			amount = randi_range(2,3)
		"speed_ghost":
			amount = randi_range(1,2)
		"wall_ghost":
			amount = randi_range(2,4)
		"boss_hand":
			item_spawner.spawn_item(location, "Geist Goulash")
			amount = 0
		_:
			amount = 0
	if amount != 0:
		coin_spawner.spawn_coins(location, amount)
	level_manager.enemy_killed()

func update_health_bar(new_value):
	hud.update_health(new_value)
	
func update_max_health(new_value):
	hud.update_max_health(new_value)

func update_coin_count(amount):
	Globals.currentCoinCount += amount
	hud.update_coin_count()

func resetItemInventory():
	for slot in range(0,6):
			if Globals.currentPlayer.item_inv.slots[slot].item == PHOTO:
				Globals.currentPlayer.item_inv.slots[slot].amount = 1
			else:
				Globals.currentPlayer.item_inv.slots[slot].item = null
		
func resetUpgradeInventory():
	for slot in range(0,6):
		Globals.currentPlayer.upg_inv.slots[slot].item = null
		
func resetWeaponInventory():
	for slot in range(1,6):
		Globals.currentPlayer.weapon_inv.slots[slot].item = null

func game_over():
	var game_over_screen = GAMEOVER.instantiate()
	add_child(game_over_screen)
	if game_win_flag:
		game_over_screen.set_text("GAME OVER?")
	get_tree().paused = true

func game_win():
	hud.fade_to_white()
	Globals.currentPlayer.health_component.invincible = true
	Globals.currentPlayer.pause()
	Globals.currentPlayer.game_end = true
	for enemy in enemy_spawner.get_enemies():
		enemy.queue_free()
	var tween = create_tween()
	tween.tween_property(audio_manager.currentMusic, "volume_db", -35, 30)
	await tween.finished
	audio_manager.gameEnd = true
	audio_manager.currentMusic.playing = false
	game_win_flag = true
	game_over()
