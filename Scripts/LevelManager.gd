extends Node2D

class_name LevelManager

signal level_changed(coords, hasShopkeeper, hasBoss)
signal room_spawn_enemy(location, type)
signal level_manager_item_spawn(type, location)

const SHOPKEEPER = preload("res://Scenes/shopkeeper.tscn")

const LEVEL_0_0_ = preload("res://Scenes/Levels/level(0,0).tscn")
const LEVEL_1_0_ = preload("res://Scenes/Levels/level(1,0).tscn")
const LEVEL_0_1_ = preload("res://Scenes/Levels/level(0,1).tscn")
const LEVEL_2_0_ = preload("res://Scenes/Levels/level(2,0).tscn")
const LEVEL_2_1_ = preload("res://Scenes/Levels/level(2,1).tscn")
const LEVEL_3_0_ = preload("res://Scenes/Levels/level(3,0).tscn")
const LEVEL_3_1_ = preload("res://Scenes/Levels/level(3,1).tscn")
const LEVEL__1_1_ = preload("res://Scenes/Levels/level(_1,1).tscn")
const LEVEL__2_1_ = preload("res://Scenes/Levels/level(_2,1).tscn")
const LEVEL__2_2_ = preload("res://Scenes/Levels/level(_2,2).tscn")
const LEVEL_4_1_ = preload("res://Scenes/Levels/level(4,1).tscn")
const LEVEL__3_2_ = preload("res://Scenes/Levels/level(_3,2).tscn")
const LEVEL__3_3_ = preload("res://Scenes/Levels/level(_3,3).tscn")
const LEVEL__4_2_ = preload("res://Scenes/Levels/level(_4,2).tscn")
const LEVEL_0_2_ = preload("res://Scenes/Levels/level(0,2).tscn")
const LEVEL_0_3_ = preload("res://Scenes/Levels/level(0,3).tscn")
const LEVEL_0_4_ = preload("res://Scenes/Levels/level(0,4).tscn")
const LEVEL_1_3_ = preload("res://Scenes/Levels/level(1,3).tscn")
const LEVEL__3_1_ = preload("res://Scenes/Levels/level(_3,1).tscn")
const LEVEL_3_2_ = preload("res://Scenes/Levels/level(3,2).tscn")
const LEVEL_3_3_ = preload("res://Scenes/Levels/level(3,3).tscn")
const LEVEL__1_4_ = preload("res://Scenes/Levels/level(_1,4).tscn")
const LEVEL__2_4_ = preload("res://Scenes/Levels/level(_2,4).tscn")
const LEVEL__2_5_ = preload("res://Scenes/Levels/level(_2,5).tscn")
const LEVEL__2_6_ = preload("res://Scenes/Levels/level(_2,6).tscn")
const LEVEL__3_6_ = preload("res://Scenes/Levels/level(_3,6).tscn")
const LEVEL__4_6_ = preload("res://Scenes/Levels/level(_4,6).tscn")
const LEVEL__1_6_ = preload("res://Scenes/Levels/level(_1,6).tscn")
const LEVEL__1_7_ = preload("res://Scenes/Levels/level(_1,7).tscn")
const LEVEL_0_7_ = preload("res://Scenes/Levels/level(0,7).tscn")

##Use this to start the game in a different room
@export var debug_spawn_room = Vector2i(0,0)

@onready var current_level:Level = $"Level(0,0)"
@onready var door_open_sound = $DoorOpenSound
@onready var door_close_sound = $DoorCloseSound


var hud = null
var enemy_spawner = null
var coin_spawner = null
var item_spawner = null
var character_manager = null
var current_coords = Vector2i(0,0)



var levelsDictionary = {
	Vector2i(0,0): LEVEL_0_0_,
	Vector2i(1,0): LEVEL_1_0_,
	Vector2i(0,1): LEVEL_0_1_,
	Vector2i(2,0): LEVEL_2_0_,
	Vector2i(2,1): LEVEL_2_1_,
	Vector2i(-1,1): LEVEL__1_1_,
	Vector2i(-2,1): LEVEL__2_1_,
	Vector2i(-2,2): LEVEL__2_2_,
	Vector2i(3,0): LEVEL_3_0_,
	Vector2i(3,1): LEVEL_3_1_,
	Vector2i(4,1): LEVEL_4_1_,
	Vector2i(-3,2): LEVEL__3_2_,
	Vector2i(-3,3): LEVEL__3_3_,
	Vector2i(-4,2): LEVEL__4_2_,
	Vector2i(0,2): LEVEL_0_2_,
	Vector2i(0,3): LEVEL_0_3_,
	Vector2i(0,4): LEVEL_0_4_,
	Vector2i(1,3): LEVEL_1_3_,
	Vector2i(-3,1): LEVEL__3_1_,
	Vector2i(3,2): LEVEL_3_2_,
	Vector2i(3,3): LEVEL_3_3_,
	Vector2i(-1,4): LEVEL__1_4_,
	Vector2i(-2,4): LEVEL__2_4_,
	Vector2i(-2,5): LEVEL__2_5_,
	Vector2i(-2,6): LEVEL__2_6_,
	Vector2i(-3,6): LEVEL__3_6_,
	Vector2i(-4,6): LEVEL__4_6_,
	Vector2i(-1,6): LEVEL__1_6_,
	Vector2i(-1,7): LEVEL__1_7_,
	Vector2i(0,7): LEVEL_0_7_
	
}

var storedCoinsDict = {}
var storedItemsDict = {}
var storedEnemySpawnsDict = {}
var storedEnemiesDict = {}
var shopKeeper = null

func _ready():
	current_level.queue_free()
	var new_level:Level
	
	if debug_spawn_room != Vector2i(0,0):
		new_level = levelsDictionary[debug_spawn_room].instantiate()
		current_coords = debug_spawn_room
		
	else:
		new_level = levelsDictionary[current_coords].instantiate()
	
	Globals.roomsSeen.append(current_coords)
	
	new_level.connect("change_room", switch_level)
	current_level = new_level
	add_child(new_level)
	current_level.enable_exits()

func initialize(passed_hud, passed_enemy_spawner, passed_coin_spawner, passed_item_spawner, passed_character_manager):
	hud = passed_hud
	enemy_spawner = passed_enemy_spawner
	coin_spawner = passed_coin_spawner
	item_spawner = passed_item_spawner
	character_manager = passed_character_manager
	

func switch_level(direction: Vector2i):

	door_open_sound.play()
	if Globals.currentPlayer != null:
		Globals.currentPlayer.pause()	
	await hud.fade_to_black()	
	
		
	#Place player in new location based on exit
	if Globals.currentPlayer != null:
		match direction:
			Vector2i.UP:
				Globals.currentPlayer.global_position = current_level.south_spawn.global_position
			Vector2i.DOWN:
				Globals.currentPlayer.global_position = current_level.north_spawn.global_position
			Vector2i.LEFT:
				Globals.currentPlayer.global_position = current_level.east_spawn.global_position
			Vector2i.RIGHT:
				Globals.currentPlayer.global_position = current_level.west_spawn.global_position
	
	
	#Clear and save the enemies
	storedEnemySpawnsDict[current_coords] = enemy_spawner.spawnsLeft
	storedEnemiesDict[current_coords] = {}
	for enemy in enemy_spawner.get_enemies():
		storedEnemiesDict[current_coords][enemy.global_position] = enemy.ghost_type
		enemy.call_deferred("queue_free")
	
	#Clear the ShopKeeper
	character_manager.remove_shopkeeper()
	
	#Clear and save the items
	storedItemsDict[current_coords] = {}
	for item in item_spawner.get_children():
		storedItemsDict[current_coords][item.global_position] = item.itemName
		item.call_deferred("queue_free")

	
	#Clear and save the coins
	storedCoinsDict[current_coords] = {}
	for coin in coin_spawner.get_children():
		storedCoinsDict[current_coords][coin.global_position] = coin.coin_value
		coin.call_deferred("queue_free")
	
	#Remove current Level
	current_level.call_deferred("queue_free")
	
	#Fetch and add new level
	current_coords += direction
	
	#Create New Level
	print(current_coords)
	var new_level:Level = levelsDictionary[current_coords].instantiate()
	current_level = new_level
	
	
	#setup Enemy Spawner
	enemy_spawner.bossIsAlive = new_level.bossIsAlive
	enemy_spawner.set_spawn_timer(new_level.bossIsAlive)
	if current_level.numberOfEnemySpawns > 0 or enemy_spawner.bossIsAlive:
		enemy_spawner.active = true
		enemy_spawner.spawnsLeft = current_level.numberOfEnemySpawns
		enemy_spawner.spawnType = current_level.difficulty
	else:
		enemy_spawner.active = false
		enemy_spawner.spawnsLeft = 0
		enemy_spawner.spawnType = 0
		
	#Add previously saved coins
	if storedCoinsDict.get(current_coords) != null:
		for coin in storedCoinsDict[current_coords].keys():
			coin_spawner.spawn_coins(coin, storedCoinsDict[current_coords][coin])
	
	#Add previously saved items
	if storedItemsDict.get(current_coords) != null:
		for item in storedItemsDict[current_coords].keys():
			item_spawner.spawn_item(item, storedItemsDict[current_coords][item])
	
	#Add previously saved enemies and enemy spawns
	if storedEnemiesDict.get(current_coords) != null:
		for enemy in storedEnemiesDict[current_coords].keys():
			enemy_spawner.spawn_specific_ghost_at_area(enemy, storedEnemiesDict[current_coords][enemy])
	if storedEnemySpawnsDict.has(current_coords):
		enemy_spawner.spawnsLeft = storedEnemySpawnsDict[current_coords]
	else:
		enemy_spawner.spawnsLeft = current_level.numberOfEnemySpawns
	
	
	
	add_child(new_level)
	
	#emit level change signal for map and audio
	level_changed.emit(current_coords, current_level.hasShopkeeper, current_level.bossIsAlive)
	

	
	#Create a shopkeeper
	if new_level.hasShopkeeper:
		character_manager.spawn_shopkeeper(current_coords)
		
	new_level.connect("change_room", switch_level)
	new_level.connect("spawn_enemy", room_specific_enemy_spawn)
	new_level.connect("spawn_room_item", room_specific_item_spawn)
	
	#Clear glitched beams
	if Globals.currentPlayer != null:
		Globals.currentPlayer.clear_beams()
	
	#Document that the new room has been seen
	if Globals.roomsSeen.find(current_coords) == -1:
		Globals.roomsSeen.append(current_coords)
		current_level.on_first_enter()
		
	new_level.on_every_enter()
	
	await hud.unfade_from_black()
	if Globals.currentPlayer != null:
		Globals.currentPlayer.unpause()
	current_level.enable_exits()
	door_close_sound.play()

			

func enemy_killed():
	current_level.numberOfEnemySpawns -= 1

func room_specific_enemy_spawn(type, location):
	emit_signal("room_spawn_enemy", location, type)

func room_specific_item_spawn(type, location):
	emit_signal("level_manager_item_spawn", type, location)
