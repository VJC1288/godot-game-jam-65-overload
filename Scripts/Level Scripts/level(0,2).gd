extends Level

class_name Level_0_2


func on_first_enter():
	
	spawn_wall_ghost(Vector2(277,55))
	spawn_wall_ghost(Vector2(120,140))
	spawn_wall_ghost(Vector2(43,55))
	
func spawn_wall_ghost(location):
		
		var type = "wall_ghost"
		emit_signal("spawn_enemy", type, location)
