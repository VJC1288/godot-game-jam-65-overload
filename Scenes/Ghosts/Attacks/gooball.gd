extends CharacterBody2D

class_name GooBall

signal createGooPuddle()

const GOO_PUDDLE = preload("res://Scenes/Ghosts/Attacks/goo_puddle.tscn")

@onready var hurt_box = $HurtBox
@onready var goo_ball = $"."
@onready var explode_timer = $ExplodeTimer

@export var team: Globals.Teams = Globals.Teams.ENEMIES
@export var speed: int
@export var damage: int

var direction: Vector2

func _ready():
	hurt_box.initialize_team(team)
	hurt_box.set_damage(damage)
	direction = global_position.direction_to(Globals.currentPlayer.global_position)
	velocity = speed * direction
	explode_timer.start(3)
	
func _physics_process(_delta):
	rotate(get_angle_to(Globals.currentPlayer.global_position))
	move_and_slide()

func _on_explode_timer_timeout():
	createGooPuddle.emit()
	goo_ball.queue_free()

func _on_hurt_box_area_entered(_area):
	createGooPuddle.emit()
	goo_ball.queue_free()
