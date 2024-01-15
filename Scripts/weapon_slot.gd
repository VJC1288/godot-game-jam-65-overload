extends ColorRect

const UI_HOVER_TEXT = preload("res://Scenes/ui_hover_text.tscn")

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var hover_panel = $HoverPanel

var hoverTextScene = null
var hoverTextLabel = null

func _ready():
		item_visual.visible = false

func update(slot: WpnInvSlot):
	if !slot.item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		hoverTextLabel = slot.item.hover_text

func _on_mouse_entered():
	hover_panel.visible = true
	if item_visual.visible == true:
		hoverTextScene = UI_HOVER_TEXT.instantiate()
		hoverTextScene.position.x = $CenterContainer.position.x
		hoverTextScene.position.y = $CenterContainer.position.y - 12
		add_child(hoverTextScene)
		hoverTextScene.text = hoverTextLabel

func _on_mouse_exited():
	hover_panel.visible = false
