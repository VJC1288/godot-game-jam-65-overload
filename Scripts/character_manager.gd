extends Node2D

const SHOPKEEPER = preload("res://Scenes/shopkeeper.tscn")


var shopKeeper
	
func spawn_shopkeeper():
	var viewport = get_viewport_rect()
	var centerOfScreen = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	
	shopKeeper = SHOPKEEPER.instantiate()
	shopKeeper.global_position = centerOfScreen
	add_child(shopKeeper)

func remove_shopkeeper():
	if shopKeeper != null:
		shopKeeper.call_deferred("queue_free")
