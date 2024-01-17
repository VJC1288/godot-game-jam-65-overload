extends Node2D

class_name ItemSpawner

signal spawner_item_collected(item_type)

const KEY = preload("res://Scenes/Pickups/key.tscn")
const ARC_EXTENDER = preload("res://Scenes/Pickups/arcExtender.tscn")
const BEAM_BATTERY_ = preload("res://Scenes/Pickups/beamBattery+.tscn")
const WRAITH_BOOTS = preload("res://Scenes/Pickups/wraith_boots.tscn")
const SPECTRE_COAT = preload("res://Scenes/Pickups/spectre_coat.tscn")

var hud = null

func initialize(passed_hud):
	hud = passed_hud

func spawn_item(location: Vector2, item_name: String = "key"):
	var spawnedItem
	
	match item_name:
		"key":
			spawnedItem = KEY.instantiate()
		"arc_extender":
			spawnedItem = ARC_EXTENDER.instantiate()
		"beam_battery":
			spawnedItem = BEAM_BATTERY_.instantiate()
		"wraith_boots":
			spawnedItem = WRAITH_BOOTS.instantiate()
		"spectre_coat":
			spawnedItem = SPECTRE_COAT.instantiate()
		
			
	spawnedItem.global_position = location
	spawnedItem.upgrade_collected.connect(hud.display_last_pickup)
	add_child(spawnedItem)
		
	#spawnedKey.item_collected.connect(key_collected)


func item_collected(item_type: String):
	emit_signal("spawner_item_collected", item_type)
	
	

