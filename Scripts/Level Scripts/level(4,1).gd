extends Level

func on_first_enter():
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	spawn_item(centerOfScreen, "Photo")
