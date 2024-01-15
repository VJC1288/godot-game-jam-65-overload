extends CanvasLayer

func _process(_delta):

	if Input.is_action_just_pressed("quit"):
		quit()
		
func quit():
	get_tree().quit()
