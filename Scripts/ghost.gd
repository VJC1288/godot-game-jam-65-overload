extends CharacterBody2D

class_name Ghost

signal ghost_died(location)

@onready var sprite_2d = $Sprite2D
@onready var panel = $Panel
@onready var energy_bar = %EnergyBar
@onready var hurt_box = $HurtBox
@onready var float_particle = $FloatParticle
@onready var death_sound = $DeathSound
@onready var shadow = $Shadow
@onready var box_container = $BoxContainer


@export var immobile: bool = false
@export var SPEED = 20.0
@export var team: Globals.Teams = Globals.Teams.ENEMIES
@export var ghost_damage: int = 20
@export var energy_to_kill: int = 100
@export var regen_rate: int
@export var death_scene: PackedScene
@export var ghost_type: String

var player_to_attack:CharacterBody2D = null
var taking_damage:bool = false
var deathState = false

var sprite2d_shader: ShaderMaterial
var startingRectX: int
var startingRectY: int
var direction: Vector2

func _ready():
	player_to_attack = Globals.currentPlayer
	energy_bar.value = 0
	energy_bar.max_value = energy_to_kill
	sprite2d_shader = sprite_2d.get("material")
	hurt_box.initialize_team(team)
	hurt_box.set_damage(ghost_damage)
	startingRectX = sprite_2d.region_rect.position.x
	startingRectY = sprite_2d.region_rect.position.y
	hurt_box.hitbysword.connect(take_damage)
	on_spawn()

func _physics_process(_delta):
	
	if energy_bar.value <= 0:
		energy_bar.visible = false
	else:
		energy_bar.visible = true
		
	if taking_damage:
		pass
	else:
		adjust_energy(regen_rate)

	
	if player_to_attack != null:

		direction = global_position.direction_to(player_to_attack.global_position)
		if direction.x > 0:
			sprite_2d.flip_h = true
			float_particle.position.x *= -1
		elif direction.x < 0:
			sprite_2d.flip_h = false
			float_particle.position.x *= -1
		
		
		if !immobile:
			velocity = direction * SPEED
		
	elif Globals.currentPlayer != null:
		player_to_attack = Globals.currentPlayer

	move_and_slide()
	match_states()

func on_spawn():
	pass
	
func match_states():
	pass

func take_damage(damage_power):
	taking_damage = true
	panel.visible = false
	adjust_energy(damage_power)
	if energy_bar.value >= energy_to_kill and deathState == false:
		kill_ghost()

func stop_damaging():
	taking_damage = false

func targetted():
	if !deathState:
		if Globals.currentTargetedGhost == null:
			panel.visible = true
			Globals.currentTargetedGhost = self
	
func untargetted():
	panel.visible = false
	Globals.currentTargetedGhost = null
	taking_damage = false

func adjust_energy(adjustment):
	energy_bar.value += adjustment
	sprite_2d.scale = Vector2(1,1) * (1 + energy_bar.value / 400.0)
	sprite2d_shader.set_shader_parameter("intensity", energy_bar.value / 250.0)
	if energy_bar.value / energy_bar.max_value >= 0.8:
		sprite_2d.region_rect.position.x = startingRectX + sprite_2d.region_rect.size.x
	else:
		sprite_2d.region_rect.position.x = startingRectX
		sprite_2d.region_rect.position.y = startingRectY

func death_effect():
		var death_animation = death_scene.instantiate()
		death_animation.position = global_position
		death_animation.emitting = true
		get_tree().current_scene.add_child(death_animation)
		
func kill_ghost():
		deathState = true
		emit_signal("ghost_died", global_position, ghost_type)
		if death_scene != null:
			death_effect()
		Globals.currentTargetedGhost = null
		Globals.currentPlayer.clear_beams()
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)
		float_particle.visible = false
		shadow.visible = false
		sprite_2d.visible = false
		panel.visible = false
		box_container.visible = false		
		death_sound.play()
		await death_sound.finished
		queue_free()
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
