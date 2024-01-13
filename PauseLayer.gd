extends CanvasLayer

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		unpause_game()
	if Input.is_action_just_pressed("quit"):
		quit()

func unpause_game():
		get_tree().paused = false
		queue_free()

func quit():
	get_tree().quit()
