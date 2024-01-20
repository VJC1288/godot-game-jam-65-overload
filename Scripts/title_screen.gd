extends CanvasLayer


@onready var settings_button = %SettingsButton
@onready var start_button = %StartButton
@onready var how_to_play = %HowToPlay
@onready var how_to_play_close = %HowToPlayClose


@onready var how_to_play_container = $"How To Play Container"



func _on_how_to_play_close_pressed():
	how_to_play_container.visible = false

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(Globals.MAIN)

func _on_how_to_play_pressed():
	how_to_play_container.visible = true
