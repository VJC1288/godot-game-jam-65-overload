extends Level


func on_first_enter():
	
	spawn_wall_ghost(Vector2(277,55))

	
func spawn_wall_ghost(location):
		
		var type = "wall_ghost"
		emit_signal("spawn_enemy", type, location)
