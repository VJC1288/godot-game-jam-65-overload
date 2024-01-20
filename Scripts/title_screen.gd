extends CanvasLayer

@onready var start = $Panel/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Start
@onready var hover_panel = %HoverPanel



func _on_start_mouse_entered():
	hover_panel.visible = true

	
func _on_start_mouse_exited():
	hover_panel.visible = false

