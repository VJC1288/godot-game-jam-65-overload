extends Node2D

class_name CoinSpawner

signal spawner_coin_collected(amount)

@export var coin1: Texture2D
@export var coin2: Texture2D
@export var coin3: Texture2D
@export var coin4: Texture2D
@export var coin5: Texture2D

const COIN = preload("res://Scenes/coin.tscn")


func spawn_coins(location: Vector2, amount:int):
	var coinToSpawn: Coin = COIN.instantiate()
	coinToSpawn.global_position = location
	add_child(coinToSpawn)
	
	var coin_text: Texture2D
	match amount:
		1:
			coin_text = coin1
		2:
			coin_text = coin2
		3:
			coin_text = coin3
		4:
			coin_text = coin4
		5:
			coin_text = coin5
		
	coinToSpawn.set_texture(coin_text)
	coinToSpawn.coin_value = amount
	coinToSpawn.connect("coin_collected", coin_collected)
	
func coin_collected(amount):
	emit_signal("spawner_coin_collected", amount)
	Globals.currentPlayer.coins_n_keys_sound.play()
