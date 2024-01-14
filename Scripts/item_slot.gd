extends ColorRect

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var hover_panel = $HoverPanel
@onready var hover_text = $HoverPanel/HoverText

func _ready():
	hover_panel.visible = false

func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		amount_text.visible = true
		amount_text.text = str(slot.amount) 

#func _on_mouse_entered(slot):
	#hover_panel.visible = true
	#hover_text.text = str(slot.item.hover_text)
