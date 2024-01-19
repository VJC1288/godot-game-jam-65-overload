extends Area2D

@onready var goo_puddle = $"."
@onready var puddle_timer = $PuddleTimer
@onready var hurt_box = $HurtBox

@export var damagePerTick: int
@export var team: Globals.Teams = Globals.Teams.ENEMIES

var in_goo: bool = false
var player = null

func _ready():
	puddle_timer.start(6)
	hurt_box.initialize_team(team)
	hurt_box.set_damage(damagePerTick)

func _on_puddle_timer_timeout():
	goo_puddle.queue_free()

func _on_damage_timer_timeout():
	if in_goo:
		player.take_damage(hurt_box.damage)

func _on_hurt_box_area_entered(area):
	if area.team != team and area.has_method("take_damage"):
		in_goo = true
		player = area
		
func _on_hurt_box_area_exited(area):
	if area.team != team and area.has_method("take_damage"):
		in_goo = false
