extends ColorRect

const UI_HOVER_TEXT = preload("res://Scenes/Inventory/ui_hover_text.tscn")

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var hover_panel = $HoverPanel

var hoverTextScene = null
var hoverTextLabel = null
var itemName = null

func _ready():
		item_visual.visible = false

func update(slot: WpnInvSlot):
	if !slot.item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		hoverTextLabel = slot.item.item_details
		itemName = slot.item.name

func _on_mouse_entered():
	hover_panel.visible = true
	if item_visual.visible == true:
		hoverTextScene = UI_HOVER_TEXT.instantiate()
		hoverTextScene.position.x = $CenterContainer.position.x + 18
		hoverTextScene.position.y = $CenterContainer.position.y - 12
		add_child(hoverTextScene)
		hoverTextScene.text = str(itemName,": ",hoverTextLabel)

func _on_mouse_exited():
	hover_panel.visible = false
	if hoverTextScene != null:
		hoverTextScene.queue_free()
