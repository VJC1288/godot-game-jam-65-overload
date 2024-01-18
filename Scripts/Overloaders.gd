extends Node2D

@onready var lock_sprite = $LockSprite
@export var exploded_texture: Texture2D
@export var door_area_to_open: Area2D

var overloaded: bool = false
var child_overloaders: Array[Overloader]



func _ready():
	for obj in get_children():
		if obj is Overloader:
			child_overloaders.append(obj)


func unlock_door():
	door_area_to_open.monitoring = true
	lock_sprite.visible = false
	
func explode_overloaders():
	for obj in child_overloaders:
		obj.sprite_2d.region_rect.position.x += 64
		obj.disabled = true
	
	#overloader_1.sprite_2d.region_rect.position.x += 64
	#overloader_2.sprite_2d.region_rect.position.x += 64
	#overloader_1.disabled = true
	#overloader_2.disabled = true

func child_overloaded(overloaded_child:Overloader):
	if !overloaded:
		var amount_overloaded: int = 1
		for obj in child_overloaders:
			if obj == overloaded_child:
				pass
			elif obj.energy_bar.value == obj.energy_bar.max_value:
				amount_overloaded += 1
			print(amount_overloaded)
				
		if amount_overloaded == child_overloaders.size():
			unlock_door()
			explode_overloaders()
			overloaded = true
			print("door open")

#
#func _on_overloader_1_overloaded():
	#if overloader_2.energy_bar.value == overloader_2.energy_bar.max_value and !overloaded:
		#unlock_door()
		#explode_overloaders()
		#overloaded = true
		#
#func _on_overloader_2_overloaded():
	#if overloader_1.energy_bar.value == overloader_1.energy_bar.max_value and !overloaded:
		#unlock_door()
		#explode_overloaders()
		#overloaded = true
