extends StaticBody2D


@export var room_coords := Vector2i(0,0)

func _ready():
	if Globals.locksUnlocked.find(room_coords) != -1:
		queue_free()


func _on_unlock_area_body_entered(body):
	
	#check if player has key
	#if yes:
	
	Globals.locksUnlocked.append(room_coords)
	call_deferred("queue_free")
	
