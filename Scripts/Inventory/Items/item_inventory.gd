extends Resource

class_name ItemInv

signal updateItemSlot_sig

const COIN_ICON = preload("res://Assets/Inventory/coin_icon.tres")

@export var slots: Array[InvSlot]
var playerItems = ItemInv

var invSize = range(0,6)

func insert(item: InvItem, amount):
	playerItems = Globals.currentPlayer.item_inv
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += amount
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = amount
	updateItemSlot_sig.emit()
		
func removeCoins(amount):
	playerItems = Globals.currentPlayer.item_inv
	for slot in invSize:
			if playerItems.slots[slot].item == COIN_ICON:
				playerItems.slots[slot].amount -= amount
				if playerItems.slots[slot].amount == 0:
					playerItems.slots[slot].item = null
				updateItemSlot_sig.emit()

func removeItem(item_resource):
	playerItems = Globals.currentPlayer.item_inv
	for slot in invSize:
		if playerItems.slots[slot].item == item_resource and playerItems.slots[slot].amount >= 1:
			playerItems.slots[slot].amount -= 1
			if playerItems.slots[slot].amount == 0:
				playerItems.slots[slot].item = null
			updateItemSlot_sig.emit()
