extends CharacterBody2D

class_name Player

signal player_health_changed(new_health)
signal player_max_health_changed(new_max_health)
signal player_death

enum PlayerMoveStates{IDLE, WALKING, STUNNED, PAUSED}

@onready var player = $"."
@onready var sprite_2d = $Sprite2D
@onready var dps_timer = $DPSTimer
@onready var animation_player = $AnimationPlayer
@onready var weapon_1 = $Weapon1
@onready var weapon_muzzle = $WeaponMuzzle
@onready var hitbox_component = $HitboxComponent
@onready var beam_container = $BeamContainer
@onready var fail_sprite = $FailSprite

@onready var beam_shock_sound = $Sounds/BeamShockSound
@onready var foot_step_sound = $Sounds/FootStepSound
@onready var beam_shock_fail_sound = $Sounds/BeamShockFailSound
@onready var coins_n_keys_sound = $Sounds/CoinsNKeysSound
@onready var swing_timer = %SwingTimer
@onready var sword_swing = %SwordSwing
@onready var sword_marker = $SwordMarker
@onready var sword_attack = %SwordAttack
@onready var sword_sound = $Sounds/SwordSound


@onready var health_component:HealthComponent = $HealthComponent

const BUNGUS_SPECTRECOAT = preload("res://Assets/bungus-spectrecoat.png")
const BUNGUS_SPECTRECOAT_2 = preload("res://Assets/bungus-spectrecoat2.png")

@export var team: Globals.Teams
@export var weapon_inv: WpnInv
@export var item_inv: ItemInv
@export var upg_inv: UpgInv


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var maxFireDistance = 100.0
var damagePower = 5.0
var speedIncrease = 1
var damagingGhost = null
var currentMoveState: PlayerMoveStates
var tractorBeam: Line2D

var paused: bool = false
var game_end = false

func _ready():
	currentMoveState = PlayerMoveStates.IDLE
	hitbox_component.initialize_team(team)
	emit_signal("player_health_changed",health_component.get_health())

func _physics_process(_delta):
	
	match currentMoveState:
		
		PlayerMoveStates.IDLE:
			
			var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
			if direction:
				currentMoveState = PlayerMoveStates.WALKING
				return
			
			velocity.x = move_toward(velocity.x, 0, SPEED * speedIncrease)
			velocity.y = move_toward(velocity.y, 0, SPEED * speedIncrease)
			
			animation_player.play("idle")
			if foot_step_sound.playing:
				foot_step_sound.stop()
			
			select_target()
			check_damaging_ghost()
			move_tractor_beam()
			swing_sword()
			
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
					sword_marker.scale.x = -1
					weapon_muzzle.position.x = 16
					fail_sprite.scale.x = -1
				elif direction.x < 0:
					sprite_2d.flip_h = false
					weapon_1.scale.x = 1
					sword_marker.scale.x = 1
					weapon_muzzle.position.x = -16
					fail_sprite.scale.x = 1
				velocity.x = direction.x * SPEED * speedIncrease
				velocity.y = direction.y * SPEED * speedIncrease
				animation_player.play("walking")
				if foot_step_sound.playing:
					pass
				else:
					foot_step_sound.play()
			
			select_target()
			check_damaging_ghost()
			move_tractor_beam()
			swing_sword()
			
			
			move_and_slide()

		PlayerMoveStates.PAUSED:
			animation_player.play("idle")
			if foot_step_sound.playing:
				foot_step_sound.stop()
		
	if health_component.current_health <= 0 and !game_end:
		player_death.emit()
	
	if !beam_shock_fail_sound.playing:
		fail_sprite.visible = false
	
func select_target():
	if Input.is_action_just_pressed("fire_beam") and Globals.currentTargetedGhost != null:
		damagingGhost = Globals.currentTargetedGhost
		
		var start_point = weapon_muzzle.position
		var end_point = damagingGhost.global_position - global_position + Vector2(0, 10)
		
		tractorBeam = Line2D.new()
		tractorBeam.add_point(start_point)
		tractorBeam.add_point(end_point *.5)
		tractorBeam.add_point(end_point*.75)
		tractorBeam.add_point(end_point)
		tractorBeam.default_color = Color.AQUAMARINE
		tractorBeam.width = 5
		tractorBeam.begin_cap_mode = Line2D.LINE_CAP_ROUND
		tractorBeam.end_cap_mode = Line2D.LINE_CAP_ROUND
		beam_container.add_child(tractorBeam)
		
		if beam_shock_sound.playing:
			pass
		else:
			beam_shock_sound.play()
			
	elif Input.is_action_just_pressed("fire_beam") and Globals.currentTargetedGhost == null:
		
		fail_sprite.visible = true			
		if !beam_shock_fail_sound.playing:
			beam_shock_fail_sound.play()
		
	
func check_damaging_ghost():
	
	if damagingGhost != null:
		if Input.is_action_just_released("fire_beam") or global_position.distance_to(damagingGhost.global_position) > maxFireDistance:
			damagingGhost.stop_damaging()
			damagingGhost = null
			clear_beams()
			if beam_shock_sound.playing:
				beam_shock_sound.stop()

			
		elif dps_timer.is_stopped():
			damagingGhost.take_damage(damagePower)
			dps_timer.start()
	else:
		clear_beams()


func move_tractor_beam():
	if tractorBeam != null and damagingGhost != null:
		var start_point = weapon_muzzle.position
		var end_point = damagingGhost.global_position - global_position + Vector2(0, 10)
		var points_size = tractorBeam.points.size()
		tractorBeam.points[points_size - 4] = start_point
		tractorBeam.points[points_size - 3] = Vector2((end_point.x + randi_range(-5, 5)) * .5, (end_point.y + randi_range(-5,5)) * .5)
		tractorBeam.points[points_size - 2] = Vector2((end_point.x + randi_range(-5, 5)) * .75, (end_point.y + randi_range(-5,5)) * .75)
		tractorBeam.points[points_size - 1] = end_point 


func collect_weapon(weapon: InvWpn, amount):
	weapon_inv.insert(weapon, amount)
	if weapon.name == "Ghost Buster(Sword)":
		Globals.hasGhostBusterSword = true
		Globals.hud.swing_timer_label.visible = true
		Globals.hud.buster_sword_panel.visible = true

func collect_item(item: InvItem, amount):
	item_inv.insert(item, amount)
	if item != null:
		if item.name == "Key":
			coins_n_keys_sound.play()
	
func collect_instantItem(item):
	if item == "Geist Goulash":
		health_component.adjust_health(20)
		
func bought_item(amount):
	item_inv.removeCoins(amount)

func used_item(item_resource, correctSlot):
	item_inv.removeItem(item_resource, correctSlot)

func collect_upgrade(upgrade, amount):
	upg_inv.insert(upgrade, amount)
	if upgrade.name == "Coin Attractor":
		Globals.hasCoinAttractor = true
	if upgrade.name == "Arc Extender":
		maxFireDistance += 10
	if upgrade.name == "Beam Battery+":
		damagePower += 2
	if upgrade.name == "Wraith Boots":
		speedIncrease += .1
	if upgrade.name == "Spectre Coat":
		var healthIncrease = 25
		health_component.adjust_max_health(healthIncrease)
		health_component.adjust_health(healthIncrease)
		if sprite_2d.texture == BUNGUS_SPECTRECOAT:
			sprite_2d.texture = BUNGUS_SPECTRECOAT_2
		else:
			sprite_2d.texture = BUNGUS_SPECTRECOAT

func _on_health_component_health_changed(new_health):
	emit_signal("player_health_changed", new_health)
	
func _on_health_component_max_health_changed(new_max_health):
	player_max_health_changed.emit(new_max_health)
	
	
func pause():
	currentMoveState = PlayerMoveStates.PAUSED

func unpause():
	currentMoveState = PlayerMoveStates.IDLE

func clear_beams():
	for i in beam_container.get_children():
		i.queue_free()
	if beam_shock_sound.playing:
		beam_shock_sound.stop()

func swing_sword():
	if Globals.hasGhostBusterSword and Input.is_action_just_pressed("swingsword") and swing_timer.time_left == 0:
			sword_swing.play("swing")
			swing_timer.start(5)
			sword_sound.play()
