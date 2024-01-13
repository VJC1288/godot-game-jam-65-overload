extends CharacterBody2D

class_name Ghost

@onready var sprite_2d = $Sprite2D
@onready var panel = $Panel
@onready var energy_bar = %EnergyBar

@export var SPEED = 20.0

var player_to_attack:CharacterBody2D = null
var taking_damage:bool = false

func _ready():
	player_to_attack = Globals.currentPlayer
	energy_bar.value = 0

func _physics_process(_delta):
	
	if energy_bar.value <= 0:
		energy_bar.visible = false
	else:
		energy_bar.visible = true
		
	if taking_damage:
		pass
	else:
		energy_bar.value -= 1

	
	if player_to_attack != null:

		var direction = global_position.direction_to(player_to_attack.global_position)
		if direction.x > 0:
			sprite_2d.flip_h = true
		elif direction.x < 0:
			sprite_2d.flip_h = false	
		
		velocity = direction * SPEED
		
	elif Globals.currentPlayer != null:
		player_to_attack = Globals.currentPlayer

	move_and_slide()

func take_damage(damage_power):
	taking_damage = true
	energy_bar.value += damage_power
	if energy_bar.value >= 100:
		queue_free()

func stop_damaging():
	taking_damage = false


func targetted():
	panel.visible = true
	Globals.currentTargetedGhost = self
	
	
func untargetted():
	panel.visible = false
	Globals.currentTargetedGhost = null
	taking_damage = false
