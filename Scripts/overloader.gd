extends Node2D

class_name Overloader

signal overloaded(location)

@onready var regen_timer = $RegenTimer
@onready var sprite_2d = $Sprite2D
@onready var panel = $Panel
@onready var energy_bar = %EnergyBar

@export var immobile: bool = false
@export var team: Globals.Teams = Globals.Teams.ENEMIES
@export var energy_to_kill: int = 100
@export var regen_rate: int

var taking_damage:bool = false

func _ready():
	energy_bar.value = 0
	energy_bar.max_value = energy_to_kill
	energy_bar.rotation = 90
	
func _physics_process(_delta):
	
	if energy_bar.value <= 0:
		energy_bar.visible = false
	else:
		energy_bar.visible = true
		
	if taking_damage:
		pass
	elif regen_timer:
		adjust_energy(regen_rate)

func take_damage(damage_power):
	taking_damage = true
	panel.visible = false
	adjust_energy(damage_power)
	if energy_bar.value >= energy_to_kill:
		emit_signal("overloaded", global_position)

func stop_damaging():
	taking_damage = false

func targetted():
	if Globals.currentTargetedGhost == null:
		panel.visible = true
		Globals.currentTargetedGhost = self
	
func untargetted():
	panel.visible = false
	Globals.currentTargetedGhost = null
	taking_damage = false

func adjust_energy(adjustment):
	energy_bar.value += adjustment

func _on_regen_timer_timeout():
	
