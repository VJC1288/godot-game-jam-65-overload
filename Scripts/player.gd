extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var dps_timer = $DPSTimer
@onready var animation_player = $AnimationPlayer

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var max_fire_distance = 100.0
var damage_power = 5.0
var targetted_ghost: CharacterBody2D

func _physics_process(delta):


	var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
	direction = direction.normalized()
	if direction:
		if direction.x > 0:
			sprite_2d.flip_h = true
		elif direction.x < 0:
			sprite_2d.flip_h = false
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		animation_player.play("walking")
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animation_player.play("idle")
	
	if Globals.current_targetted_ghost != null:
		if Input.is_action_pressed("fire_beam"):
			if global_position.distance_to(Globals.current_targetted_ghost.global_position) < max_fire_distance and dps_timer.is_stopped():
				damage_ghost()
				dps_timer.start()
		if Input.is_action_just_released("fire_beam") or global_position.distance_to(Globals.current_targetted_ghost.global_position) > max_fire_distance:
			stop_damaging_ghost()

	move_and_slide()
	
func damage_ghost():
	Globals.current_targetted_ghost.take_damage(damage_power)

func stop_damaging_ghost():
	Globals.current_targetted_ghost.stop_damaging()
