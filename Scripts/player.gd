extends CharacterBody2D

enum PlayerMoveStates{IDLE, WALKING, DODGE_ROLLING, STUNNED}
enum PlayerAttackStates{FIRING, NOT_FIRING}

@onready var sprite_2d = $Sprite2D
@onready var dps_timer = $DPSTimer
@onready var animation_player = $AnimationPlayer
@onready var weapon_1 = $Weapon1
@onready var weapon_muzzle = $WeaponMuzzle


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var maxFireDistance = 100.0
var damagePower = 5.0
var damagingGhost: Ghost = null
var currentMoveState: PlayerMoveStates
var currentAttackState: PlayerAttackStates
var tractorBeam: Line2D



func _ready():
	currentMoveState = PlayerMoveStates.IDLE
	

func _physics_process(_delta):
	

	match currentMoveState:

		
		PlayerMoveStates.IDLE:
			
			var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
			if direction:
				currentMoveState = PlayerMoveStates.WALKING
				return
			
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			
			animation_player.play("idle")
			
			select_target()
			check_damaging_ghost()
			move_tractor_beam()
			
			move_and_slide()
			
		PlayerMoveStates.WALKING:
			
			var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
			if direction == Vector2.ZERO:
				currentMoveState = PlayerMoveStates.IDLE
				return
			
			else:
				direction = direction.normalized()
				if direction.x > 0:
					sprite_2d.flip_h = true
					weapon_1.scale.x = -1
					weapon_muzzle.position.x = 14
				elif direction.x < 0:
					sprite_2d.flip_h = false
					weapon_1.scale.x = 1
					weapon_muzzle.position.x = -14
				velocity.x = direction.x * SPEED
				velocity.y = direction.y * SPEED
				animation_player.play("walking")
			
			select_target()
			check_damaging_ghost()
			move_tractor_beam()
			
			move_and_slide()
			
		PlayerMoveStates.DODGE_ROLLING:
			pass


func select_target():
	if Input.is_action_just_pressed("fire_beam") and Globals.currentTargetedGhost != null:
		damagingGhost = Globals.currentTargetedGhost
		
		var start_point = weapon_muzzle.position
		var end_point = damagingGhost.global_position - global_position
		
		tractorBeam = Line2D.new()
		tractorBeam.add_point(start_point)
		tractorBeam.add_point(end_point/2)
		tractorBeam.add_point(end_point)
		tractorBeam.default_color = Color.AQUAMARINE
		tractorBeam.width = 5
		tractorBeam.end_cap_mode = Line2D.LINE_CAP_ROUND
		add_child(tractorBeam)
		
	
func check_damaging_ghost():
	
	if damagingGhost != null:
		if Input.is_action_just_released("fire_beam") or global_position.distance_to(damagingGhost.global_position) > maxFireDistance:
			damagingGhost.stop_damaging()
			damagingGhost = null
			tractorBeam.queue_free()
			
		elif dps_timer.is_stopped():
			damagingGhost.take_damage(damagePower)
			dps_timer.start()
	else:
		if tractorBeam != null:
			tractorBeam.queue_free()

func move_tractor_beam():
	if tractorBeam != null and damagingGhost != null:
		var start_point = weapon_muzzle.position
		var end_point = damagingGhost.global_position - global_position
		var points_size = tractorBeam.points.size()
		tractorBeam.points[0] = start_point
		tractorBeam.points[points_size - 1] = end_point
		tractorBeam.points[points_size - 2] = Vector2((end_point.x + randi_range(-10, 10)) / 2, (end_point.y + randi_range(-10,10)) / 2)
		
