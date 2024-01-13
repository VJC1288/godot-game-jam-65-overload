extends CharacterBody2D

enum PlayerMoveStates{IDLE, WALKING, DODGE_ROLLING, STUNNED}
enum PlayerAttackStates{FIRING, NOT_FIRING}

@onready var sprite_2d = $Sprite2D
@onready var dps_timer = $DPSTimer
@onready var animation_player = $AnimationPlayer
@onready var weapon_1 = $Weapon1


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var maxFireDistance = 100.0
var damagePower = 5.0
var damagingGhost: Ghost = null
var currentMoveState: PlayerMoveStates
var currentAttackState: PlayerAttackStates

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
					$Weapon1.flip_h = true
					$Weapon1.offset = Vector2(7,2)
				elif direction.x < 0:
					sprite_2d.flip_h = false
					$Weapon1.flip_h = false
					$Weapon1.offset = Vector2(-7,2)
				velocity.x = direction.x * SPEED
				velocity.y = direction.y * SPEED
				animation_player.play("walking")
			
			select_target()
			check_damaging_ghost()
			
			move_and_slide()
			
		PlayerMoveStates.DODGE_ROLLING:
			pass


func select_target():
	if Input.is_action_just_pressed("fire_beam") and Globals.currentTargetedGhost != null:
		damagingGhost = Globals.currentTargetedGhost
	
func check_damaging_ghost():
	
	if damagingGhost != null:
		if Input.is_action_just_released("fire_beam") or global_position.distance_to(damagingGhost.global_position) > maxFireDistance:
			damagingGhost.stop_damaging()
			damagingGhost = null
			
			
		elif dps_timer.is_stopped():
			damagingGhost.take_damage(damagePower)
			dps_timer.start()

	
