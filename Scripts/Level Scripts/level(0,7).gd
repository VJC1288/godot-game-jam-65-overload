extends Level



func on_first_enter():
	spawn_boss()
	

func spawn_boss():
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	var location 
	var type 
	
	type = "boss_hand"
	location = Vector2(centerOfScreen.x + 60, centerOfScreen.y - 20)
	emit_signal("spawn_enemy", type, location)
	
	location = Vector2(centerOfScreen.x + 100, centerOfScreen.y)
	type = "boss_ghost"
	emit_signal("spawn_enemy", type, location)
	
	type = "boss_hand"
	location = Vector2(centerOfScreen.x + 75, centerOfScreen.y + 40)
	emit_signal("spawn_enemy", type, location)
