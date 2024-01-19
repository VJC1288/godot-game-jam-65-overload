extends Timer

@onready var wall_ghost: Ghost = $".."
@onready var animation_player = $"../AnimationPlayer"
@onready var attack_source = $"../AttackSource"

const GOOBALL = preload("res://Scenes/Ghosts/Attacks/gooball.tscn")
const GOO_PUDDLE = preload("res://Scenes/Ghosts/Attacks/goo_puddle.tscn")

var goo_ball: Node2D

func _physics_process(_delta):

	if wall_ghost.direction.x > 0:
		attack_source.position.x *= -1
	elif wall_ghost.direction.x < 1:
		attack_source.position.x *= -1

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
