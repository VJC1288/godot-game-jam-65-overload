extends Node2D

class_name LevelManager

const SHOPKEEPER = preload("res://Scenes/shopkeeper.tscn")

const LEVEL_0_0_ = preload("res://Scenes/Levels/level(0,0).tscn")
const LEVEL_1_0_ = preload("res://Scenes/Levels/level(1,0).tscn")
const LEVEL_0_1_ = preload("res://Scenes/Levels/level(0,1).tscn")
const LEVEL_2_0_ = preload("res://Scenes/Levels/level(2,0).tscn")
const LEVEL_2_1_ = preload("res://Scenes/Levels/level(2,1).tscn")
const LEVEL__1_1_ = preload("res://Scenes/Levels/level(_1,1).tscn")

##Use this to start the game in a different room
@export var debug_spawn_room = Vector2i(0,0)

@onready var current_level:Level = $"Level(0,0)"

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
	Vector2i(-1,1): LEVEL__1_1_
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
	else:
		new_level = levelsDictionary[current_coords].instantiate()
		
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
	
	prints(storedEnemySpawnsDict)
	#Clear the ShopKeeper
	character_manager.remove_shopkeeper()
	
	#Clear and save the keys
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
	var new_level:Level = levelsDictionary[current_coords].instantiate()
	current_level = new_level
	if current_level.numberOfEnemySpawns > 0:
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
	#Create a shopkeeper
	if new_level.hasShopkeeper:
		character_manager.spawn_shopkeeper()
		
	new_level.connect("change_room", switch_level)
	
	await hud.unfade_from_black()
	Globals.currentPlayer.unpause()
	current_level.enable_exits()

func enemy_killed():
	current_level.numberOfEnemySpawns -= 1
