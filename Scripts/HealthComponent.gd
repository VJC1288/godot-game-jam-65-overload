extends Node2D

class_name HealthComponent

signal health_changed(new_health)

@export var max_health: int
var current_health

var actor: Node2D

func _ready():
	current_health = max_health
	actor = get_parent()
	emit_signal("health_changed", current_health)
	
func get_health() -> int:
	return current_health

func adjust_health(adjustment: int):
	current_health += adjustment
	emit_signal("health_changed", current_health)
	if current_health <= 0:

		actor.queue_free()
	
