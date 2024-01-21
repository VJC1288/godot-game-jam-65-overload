extends Node2D

@onready var lock = $Lock

@export var exploded_texture: Texture2D
@export var door_area_to_open: Area2D

@onready var burst_sound = $BurstSound

var overloaded: bool = false
var child_overloaders: Array[Overloader]



func _ready():
	for obj in get_children():
		if obj is Overloader:
			obj.connect("overloaded", child_overloaded)
			child_overloaders.append(obj)
			
			


func unlock_door():
	burst_sound.play()
	lock.queue_free()
	
func explode_overloaders():
	for obj in child_overloaders:
		obj.sprite_2d.region_rect.position.x += 64
		obj.disabled = true

func child_overloaded(overloaded_child:Overloader):
	if !overloaded:
		var amount_overloaded: int = 1
		for obj in child_overloaders:
			if obj == overloaded_child:
				pass
			elif obj.energy_bar.value == obj.energy_bar.max_value:
				amount_overloaded += 1
				
		if amount_overloaded == child_overloaders.size():
			unlock_door()
			explode_overloaders()
			overloaded = true
			


