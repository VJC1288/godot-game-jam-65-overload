extends Resource

class_name UpgInv

signal updateUpgSlot_sig

@export var slots: Array[UpgInvSlot]

func insert(item: InvItem, amount):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += amount
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = amount
	updateUpgSlot_sig.emit()
