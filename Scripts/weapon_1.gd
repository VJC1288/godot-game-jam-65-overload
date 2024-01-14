extends Area2D

signal wpn1Pickup_sig()

func _on_body_entered(body):
	if body.is_in_group("player"):
		wpn1Pickup_sig.emit()
		queue_free()
