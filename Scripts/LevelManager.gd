extends Node2D

class_name LevelManager

const LEVEL_0_0_ = preload("res://Scenes/Levels/level(0,0).tscn")
const LEVEL_1_0_ = preload("res://Scenes/Levels/level(1,0).tscn")


var current_coords = Vector2i(0,0)
var hud = null
var enemy_spawner = null
var coin_spawner = null
var key_spawner = null

@onready var current_level:Level = $"Level(0,0)"


var levelsDictionary = {
	Vector2i(0,0): LEVEL_0_0_,
	Vector2i(1,0): LEVEL_1_0_
}

var storedCoinsDict = {}
var storedKeysDict = {}


func _ready():
	current_level.queue_free()
	var new_level:Level = levelsDictionary[current_coords].instantiate()
	new_level.connect("change_room", switch_level)
	current_level = new_level
	add_child(new_level)

func initialize(passed_hud, passed_enemy_spawner, passed_coin_spawner, passed_key_spawner):
	hud = passed_hud
	enemy_spawner = passed_enemy_spawner
	coin_spawner = passed_coin_spawner
	key_spawner = passed_key_spawner
	

func switch_level(direction: Vector2i):
	Globals.currentPlayer.pause()
	await hud.fade_to_black()	
	
	#Clear the enemies
	for enemy in enemy_spawner.get_enemies():
		enemy.call_deferred("queue_free")
	
	#Clear (and save?) the keys
	storedKeysDict[current_coords] = {}
	for key in key_spawner.get_children():
		storedKeysDict[current_coords][key.global_position] = "1 key"
		key.queue_free()
	
	#Clear (and save?) the coins
	storedCoinsDict[current_coords] = {}
	for coin in coin_spawner.get_children():
		storedCoinsDict[current_coords][coin.global_position] = coin.coin_value
		coin.queue_free()
	
	#Remove current Level
	current_level.queue_free()
	
	#Fetch and add new level
	current_coords += direction
	
	#Add saved coins
	if storedCoinsDict.get(current_coords) != null:
		for coin in storedCoinsDict[current_coords].keys():
			coin_spawner.spawn_coins(coin, storedCoinsDict[current_coords][coin])
	
	#Add saved keys
	if storedKeysDict.get(current_coords) != null:
		for key in storedKeysDict[current_coords].keys():
			key_spawner.spawn_key(key)
	
	var new_level:Level = levelsDictionary[current_coords].instantiate()
	new_level.connect("change_room", switch_level)
	current_level = new_level
	add_child(new_level)
	
	
	
	#Place player in new location based on exit
	if Globals.currentPlayer != null:
		match direction:
			Vector2i.UP:
				Globals.currentPlayer.global_position = new_level.south_spawn.global_position
			Vector2i.DOWN:
				Globals.currentPlayer.global_position = new_level.north_spawn.global_position
			Vector2i.LEFT:
				Globals.currentPlayer.global_position = new_level.east_spawn.global_position
			Vector2i.RIGHT:
				Globals.currentPlayer.global_position = new_level.west_spawn.global_position
	
	
	await hud.unfade_from_black()
	Globals.currentPlayer.unpause()

