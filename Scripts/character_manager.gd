extends Node2D

signal sold_item(location, type)
signal update_coin_count(amount)

const SHOPKEEPER = preload("res://Scenes/shopkeeper.tscn")


var shopKeeper
	
func spawn_shopkeeper(passed_coords: Vector2i):
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	
	shopKeeper = SHOPKEEPER.instantiate()
	shopKeeper.global_position = centerOfScreen
	shopKeeper.roomCoords = passed_coords
	shopKeeper.connect("item_purchased", bought_item_at_cost)
	add_child(shopKeeper)

func remove_shopkeeper():
	if shopKeeper != null:
		shopKeeper.call_deferred("queue_free")

func bought_item_at_cost(type, location, cost):
	pass_item_to_spawner(type, location)
	pass_cost_to_hud(cost)
	Globals.currentPlayer.bought_item(cost)

func pass_item_to_spawner(type, location):
	prints(location, type)
	emit_signal("sold_item", location, type)

func pass_cost_to_hud(passed_cost):
	emit_signal("update_coin_count", -passed_cost)
