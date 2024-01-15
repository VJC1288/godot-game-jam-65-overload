extends Resource

class_name WpnInv

signal updateWpnSlot_sig

@export var slots: Array[WpnInvSlot]

func insert(item: InvItem, amount):
	var emptyslots = slots.filter(func(slot): return slot.item == null)
	if !emptyslots.is_empty():
		emptyslots[0].item = item
		emptyslots[0].amount = amount
	updateWpnSlot_sig.emit()
