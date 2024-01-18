extends Node2D

@onready var menu = $Menu
@onready var map = $Map


func _physics_process(_delta):
	
	if Input.is_action_just_pressed("pause"):
		if menu.menu_open:
			closeAll()
		elif map.map_open:
			closeAll()
		else:
			get_tree().paused = true
			menu.open_menu()
	if Input.is_action_just_pressed("quit") and menu.menu_open:
		quit()
	if Input.is_action_just_pressed("openmap"):
		if map.map_open:
			closeAll()
		else:
			map.open_map()

func quit():
	get_tree().quit()
	
func closeAll():
	map.close_map()
	menu.close_menu()
	get_tree().paused = false
