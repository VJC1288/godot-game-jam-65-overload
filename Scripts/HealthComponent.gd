extends Node2D

class_name HealthComponent

signal health_changed(new_health)
signal max_health_changed(new_max_health)

@export var hurt_sound: AudioStreamPlayer2D
@export var max_health: int
var current_health

var actor: Node2D

var invincible: bool = false

func _ready():
	current_health = max_health
	actor = get_parent()
	emit_signal("health_changed", current_health)
	
func get_health() -> int:
	return current_health

func adjust_health(adjustment: int):
	
	if adjustment > 0:
		current_health += adjustment
		emit_signal("health_changed", current_health)
	elif !invincible:

		if actor.is_in_group("player"):
			invincible = true
			hurt_sound.play()
			current_health += adjustment
			emit_signal("health_changed", current_health)
			if current_health <= 0:
				actor.queue_free()
			
			var tween = create_tween()
			tween.tween_property(actor, "modulate", Color(1,1,1, 0), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 1), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 0), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 1), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 0), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 1), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 0), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 1), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 0), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 1), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 0), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 1), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 0), 0.1)
			tween.tween_property(actor, "modulate", Color(1,1,1, 1), 0.1)

			
			await tween.finished
			invincible = false
	



func adjust_max_health(adjustment: int):
	max_health += adjustment
	max_health_changed.emit(max_health)
