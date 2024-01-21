extends CanvasLayer

func _process(_delta):

	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_packed(Globals.TITLE_SCREEN)

		
		
func quit():
	get_tree().quit()
