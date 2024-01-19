extends Timer

enum WallStates{BOTTOM, TOP, LEFT, RIGHT}

@onready var wall_ghost: Ghost = $".."
@onready var animation_player = $"../AnimationPlayer"
@onready var attack_source = $"../AttackSource"

const GOOBALL = preload("res://Scenes/Ghosts/Attacks/gooball.tscn")
const GOO_PUDDLE = preload("res://Scenes/Ghosts/Attacks/goo_puddle.tscn")

@export var bottomWall: bool
@export var topWall: bool
@export var leftWall: bool
@export var rightWall: bool

var currentWallState: WallStates

var goo_ball: Node2D

func _ready():
	if bottomWall:
		currentWallState = WallStates.BOTTOM
	if topWall:
		currentWallState = WallStates.TOP
	if leftWall:
		currentWallState = WallStates.LEFT
	if rightWall:
		currentWallState = WallStates.RIGHT
		
		
		
func _physics_process(_delta):
	
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

	
func _on_timeout():
	animation_player.play("wallGhostAttack")
	goo_ball = GOOBALL.instantiate()
	goo_ball.position = attack_source.position
	wall_ghost.add_child(goo_ball)
	goo_ball.createGooPuddle.connect(makePuddle)
	
func makePuddle():
	var goo_puddle = GOO_PUDDLE.instantiate()
	goo_puddle.set_deferred("rotation", randf_range(0,360))
	goo_puddle.set_deferred("position", goo_ball.position)
	wall_ghost.call_deferred("add_child", goo_puddle)
