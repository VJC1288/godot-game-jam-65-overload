extends Node2D

class_name KeySpawner

signal spawner_key_collected()

const KEY = preload("res://Scenes/key.tscn")


func spawn_key(location: Vector2):
	var spawnedKey = KEY.instantiate()
	spawnedKey.global_position = location
	add_child(spawnedKey)
		
	spawnedKey.key_collected.connect(key_collected)
	
func key_collected():
	emit_signal("spawner_key_collected")
	
	

