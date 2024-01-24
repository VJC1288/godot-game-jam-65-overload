extends Node2D

signal item_purchased(item_slot, cost)

@onready var cost_label = $CostLabel
@onready var box_select = $BoxSelect
@export var cost = 0

var item_for_sale: Node2D
var item_name_for_sale:String
var purchased = false

func set_cost(passed_cost):
	cost = passed_cost
	cost_label.text = "$" + str(passed_cost)

func _on_select_area_mouse_entered():
	box_select.visible = true
	Globals.lastPickup = item_name_for_sale
	Globals.hud.display_shop_info()


func _on_select_area_mouse_exited():
	box_select.visible = false
	Globals.hud.hide_shop_info()


func _on_select_area_input_event(_viewport, event, _shape_idx):
	if !purchased:
		if Globals.currentCoinCount >= cost:
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
					emit_signal("item_purchased", self, cost)

