extends Node2D

@onready var menu = $Menu
@onready var map = $Map
@onready var settings = $Settings


func _physics_process(_delta):
	
	if Input.is_action_just_pressed("pause"):
		
		if menu.menu_open:
			closeAll()
		else:
			closeAll()
			menu.open_menu()
			get_tree().paused = true

	if Input.is_action_just_pressed("openmap"):
		if map.map_open:
			closeAll()
		else:
			closeAll()
			map.open_map()
			get_tree().paused = true
			
	if Input.is_action_just_pressed("opensettings"):
		if settings.settings_open:
			closeAll()
		else:
			closeAll()
			settings.open_settings()
			get_tree().paused = true


func closeAll():
	map.close_map()
	menu.close_menu()
	settings.close_settings()
	get_tree().paused = false
