extends Resource

class_name UpgInv

signal updateUpgSlot_sig

@export var slots: Array[UpgInvSlot]

func insert(upgrade: InvUpg, amount):
	var itemslots = slots.filter(func(slot): return slot.item == upgrade)
	if !itemslots.is_empty():
		itemslots[0].amount += amount
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = upgrade
			emptyslots[0].amount = amount
	updateUpgSlot_sig.emit()
