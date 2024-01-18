extends Node2D

@onready var overloader_1: Overloader = %Overloader1
@onready var overloader_2: Overloader = %Overloader2
@onready var level_3_1_ = $".."

@export var exploded_texture: Texture2D

var overloaded: bool = false

func unlock_door():
	level_3_1_.east_exit_area.monitoring = true
	
func explode_overloaders():
	overloader_1.sprite_2d.region_rect.position.x += 64
	overloader_2.sprite_2d.region_rect.position.x += 64
	overloader_1.disabled = true
	overloader_2.disabled = true

func _on_overloader_1_overloaded():
	if overloader_2.energy_bar.value == overloader_2.energy_bar.max_value and !overloaded:
		unlock_door()
		explode_overloaders()
		overloaded = true
		
func _on_overloader_2_overloaded():
	if overloader_1.energy_bar.value == overloader_1.energy_bar.max_value and !overloaded:
		unlock_door()
		explode_overloaders()
		overloaded = true
