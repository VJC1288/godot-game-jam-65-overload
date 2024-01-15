extends Area2D


var team: Globals.Teams

var damage: int

func initialize_team(passed_team: Globals.Teams):
	team = passed_team
	

func set_damage(passed_damage:int):
	damage = passed_damage


func _on_area_entered(area):

	if area.team != team and area.has_method("take_damage"):
		area.take_damage(damage)
