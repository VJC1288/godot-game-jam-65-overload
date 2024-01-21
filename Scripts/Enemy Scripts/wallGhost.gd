extends Ghost

class_name WallGhost

enum WallStates{BOTTOM=1, TOP, LEFT, RIGHT, OFF}

const GOOBALL = preload("res://Scenes/Ghosts/Attacks/gooball.tscn")
const GOO_PUDDLE = preload("res://Scenes/Ghosts/Attacks/goo_puddle.tscn")

@onready var puddle_container = $PuddleContainer
@onready var wall_ghost = $"."
@onready var attack_timer = %AttackTimer
@onready var animation_player = %AnimationPlayer
@onready var attack_source = %AttackSource
@onready var bubble_shot_sound = $BubbleShotSound
@onready var bubble_land_sound = $BubbleLandSound


var currentWallState: WallStates
var goo_ball: Node2D

func on_spawn():
	
	checkWall()
	
	attack_timer.start(randf_range(2,3))

func match_states():

	match currentWallState:
		
		WallStates.BOTTOM:
			if wall_ghost.direction.x > 0:
				attack_source.position.x = 15
			elif wall_ghost.direction.x < 0:
				attack_source.position.x = -15
				
		WallStates.TOP:
			if wall_ghost.direction.x < 0:
				attack_source.position.x = 15
				wall_ghost.sprite_2d.flip_h = true
			elif wall_ghost.direction.x > 0:
				attack_source.position.x = -15
				wall_ghost.sprite_2d.flip_h = false
				
		WallStates.LEFT:
			if wall_ghost.direction.y > 0:
				wall_ghost.sprite_2d.flip_h = true
				attack_source.position.x = 15
			elif wall_ghost.direction.y < 0:
				wall_ghost.sprite_2d.flip_h = false
				attack_source.position.x = -15

		WallStates.RIGHT:
			if wall_ghost.direction.y < 0:
				wall_ghost.sprite_2d.flip_h = true
				attack_source.position.x = 15
			elif wall_ghost.direction.y > 0:
				wall_ghost.sprite_2d.flip_h = false
				attack_source.position.x = -15
			
		WallStates.OFF:
			pass

func _on_attack_timer_timeout():
	if !deathState:
		animation_player.play("wallGhostAttack")
		goo_ball = GOOBALL.instantiate()
		goo_ball.position = attack_source.position
		wall_ghost.add_child(goo_ball)
		goo_ball.createGooPuddle.connect(makePuddle)
		attack_timer.start(randf_range(2,3))
		bubble_shot_sound.play()
		rotateGooShadow()
	
func makePuddle():
	var goo_puddle = GOO_PUDDLE.instantiate()
	goo_puddle.set_deferred("rotation", randf_range(0,360))
	goo_puddle.set_deferred("position", goo_ball.position)
	puddle_container.call_deferred("add_child", goo_puddle)
	bubble_land_sound.play()

func checkWall():
	if wall_ghost.global_position.x > (get_viewport_rect().size.x * 8/10):
		currentWallState = WallStates.RIGHT
	elif wall_ghost.global_position.x <= (get_viewport_rect().size.x * 2/10):
		currentWallState = WallStates.LEFT
	else:
		currentWallState = WallStates.BOTTOM
		
func rotateGooShadow():
	
	match currentWallState:
		
		WallStates.BOTTOM:
			goo_ball.look_at(goo_ball.global_position + Vector2.UP)
		WallStates.TOP:
			pass
		WallStates.LEFT:
			goo_ball.look_at(goo_ball.global_position + Vector2.RIGHT)
		WallStates.RIGHT:
			goo_ball.look_at(goo_ball.global_position + Vector2.RIGHT)
	
