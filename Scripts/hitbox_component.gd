extends Area2D

@export var health_component: HealthComponent

var team: Globals.Teams


func initialize_team(passed_team: Globals.Teams):
	team = passed_team
	

func take_damage(amount):
	if health_component != null:
		health_component.adjust_health(amount)
