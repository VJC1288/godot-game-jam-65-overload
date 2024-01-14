extends ColorRect

@onready var weapon_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay

func update(item: InvItem):
	if !item:
		weapon_visual.visible = false
	else:
		weapon_visual.visible = true
		weapon_visual.texture = item.texture
