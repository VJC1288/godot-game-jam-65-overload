extends Node2D

class_name ItemSpawner

signal spawner_item_collected(item_type)

const KEY = preload("res://Scenes/Pickups/key.tscn")
const ARC_EXTENDER = preload("res://Scenes/Pickups/arcExtender.tscn")
const BEAM_BATTERY_ = preload("res://Scenes/Pickups/beamBattery+.tscn")
const WRAITH_BOOTS = preload("res://Scenes/Pickups/wraith_boots.tscn")
const SPECTRE_COAT = preload("res://Scenes/Pickups/spectre_coat.tscn")
const GEIST_GOULASH = preload("res://Scenes/Pickups/geist_goulash.tscn")

var hud = null

func initialize(passed_hud):
	hud = passed_hud

func spawn_item(location: Vector2, item_name: String = "key"):

	var spawnedItem
	
	match item_name:
		"key":
			spawnedItem = KEY.instantiate()
		"Arc Extender":
			spawnedItem = ARC_EXTENDER.instantiate()
		"Beam Battery":
			spawnedItem = BEAM_BATTERY_.instantiate()
		"Wraith Boots":
			spawnedItem = WRAITH_BOOTS.instantiate()
		"Spectre Coat":
			spawnedItem = SPECTRE_COAT.instantiate()
		"Geist Goulash":
			spawnedItem = GEIST_GOULASH.instantiate()
			
	spawnedItem.global_position = location
	
	if spawnedItem.instantItem:
		spawnedItem.item_collected.connect(hud.display_last_pickup)
	
	spawnedItem.upgrade_collected.connect(hud.display_last_pickup)
	add_child(spawnedItem)
		
	#spawnedKey.item_collected.connect(key_collected)


func item_collected(item_type: String):
	emit_signal("spawner_item_collected", item_type)
	
	

