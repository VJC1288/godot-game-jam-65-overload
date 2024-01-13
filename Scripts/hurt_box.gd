extends Area2D


var team: Globals.Teams

@export var damage: int

func initialize_team(passed_team: Globals.Teams):
	team = passed_team
	

func _on_area_entered(area):

	if area.team != team and area.has_method("take_damage"):
		area.take_damage(damage)
