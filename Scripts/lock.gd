extends StaticBody2D

const KEY_RESOURCE = preload("res://Assets/Inventory/key_resource.tres")

@onready var unlock_sound = $UnlockSound


@export var room_coords := Vector2i(0,0)
var playerItems: ItemInv 

var slots: Array[InvSlot]
var invSize = range(0,6)
var hasKey: bool
var correctSlot: int

func _ready():
	if Globals.locksUnlocked.find(room_coords) != -1:
		queue_free()

func checkForKey():
	playerItems = Globals.currentPlayer.item_inv
	for slot in invSize:
		if playerItems.slots[slot].item == KEY_RESOURCE:
			hasKey = true
			correctSlot = slot
			#print("Slot ",slot, ": has a Key.")
		#else:
			#print("Slot ",slot, ": has no Key.")

func _on_unlock_area_body_entered(_body):
	checkForKey()
	if hasKey:
		Globals.currentPlayer.used_item(KEY_RESOURCE, correctSlot)
		Globals.locksUnlocked.append(room_coords)
		unlock_sound.play()
		await unlock_sound.finished
		call_deferred("queue_free")
	else:
		print("Player has no Key!")
