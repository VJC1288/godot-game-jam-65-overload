extends CanvasLayer

@onready var game_over_text = %"Game Over Text"

func _process(_delta):

	if Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		Globals.resetGlobals()
		get_tree().change_scene_to_packed(Globals.TITLE_SCREEN)

func set_text(text):
	game_over_text.text = text
