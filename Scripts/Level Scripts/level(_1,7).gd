extends Level


const PHOTO = preload("res://Assets/Inventory/photo.tres")
@onready var ground = $Ground
@onready var boss_lock = $BossLock

var filledTopRightPhoto = Vector2i(7,7)
var filledMidTopPhoto = Vector2i(7,9)
var filledMidBottomPhoto = Vector2i(7,8)
var filledBottomRightPhoto = Vector2i(6,9)

func check_for_photos() -> int:
	var invSize = range(0,6)
	var photo_amount = 0
	var playerItems = Globals.currentPlayer.item_inv
	for slot in invSize:
		if playerItems.slots[slot].item == PHOTO:
			photo_amount = playerItems.slots[slot].amount
	return photo_amount
			
func on_every_enter():
	var photo_amount = check_for_photos()
	
	var topRightPhoto = Vector2i(9,0)
	var midTopPhoto = Vector2i(9,1)
	var midBottomPhoto = Vector2i(9,4)
	var bottomRightPhoto = Vector2i(9,5)
	

	match photo_amount:
		1:
			ground.set_cell(1, topRightPhoto, 0, filledTopRightPhoto)
		2:
			ground.set_cell(1, topRightPhoto, 0, filledTopRightPhoto)
			ground.set_cell(1, midTopPhoto, 0, filledMidTopPhoto)
		3:
			ground.set_cell(1, topRightPhoto, 0, filledTopRightPhoto)
			ground.set_cell(1, midTopPhoto, 0, filledMidTopPhoto)
			ground.set_cell(1, midBottomPhoto, 0, filledMidBottomPhoto)
		4:
			ground.set_cell(1, topRightPhoto, 0, filledTopRightPhoto)
			ground.set_cell(1, midTopPhoto, 0, filledMidTopPhoto)
			ground.set_cell(1, midBottomPhoto, 0, filledMidBottomPhoto)
			ground.set_cell(1, bottomRightPhoto, 0, filledBottomRightPhoto)
			unlock_boss()
		_:
			ground.set_cell(1, topRightPhoto, 0, filledTopRightPhoto)
			ground.set_cell(1, midTopPhoto, 0, filledMidTopPhoto)
			ground.set_cell(1, midBottomPhoto, 0, filledMidBottomPhoto)
			ground.set_cell(1, bottomRightPhoto, 0, filledBottomRightPhoto)
			unlock_boss()
			
func unlock_boss():
	boss_lock.queue_free()
