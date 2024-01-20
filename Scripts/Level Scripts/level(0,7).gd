extends Level



func on_first_enter():
	spawn_boss()
	

func spawn_boss():
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	var location = Vector2(centerOfScreen.x + 75, centerOfScreen.y)
	var type = "boss"
	emit_signal("spawn_enemy", type, location)

	type = "boss_hand"
	emit_signal("spawn_enemy", type, location)
	
	type = "boss_hand"
	emit_signal("spawn_enemy", type, location)
