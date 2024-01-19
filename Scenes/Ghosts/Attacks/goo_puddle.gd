extends Area2D

@onready var goo_puddle = $"."
@onready var puddle_timer = $PuddleTimer

func _ready():
	puddle_timer.start(6)

func _on_puddle_timer_timeout():
	goo_puddle.queue_free()
