extends CenterContainer

@onready var hover_panel = $HoverPanel


func _on_mouse_entered():
	hover_panel.visible = true
	
func _on_mouse_exited():
	hover_panel.visible = false
