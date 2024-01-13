extends Node2D

signal health_changed(new_health)

@export var max_health: int
var current_health


func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health)
	
func get_health() -> int:
	return current_health

func adjust_health(adjustment: int):
	current_health += adjustment
	emit_signal("health_changed", current_health)
