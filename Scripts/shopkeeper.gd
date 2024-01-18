extends CharacterBody2D

@onready var shop_area = $ShopArea
@onready var embarrassed_area = $EmbarrassedArea
@onready var sprite_2d = $Sprite2D




func _on_embarrassed_area_body_entered(body):
	sprite_2d.region_rect.position.x = 288



func _on_shop_area_body_entered(body):
	pass # Replace with function body.


func _on_embarrassed_area_body_exited(body):
	sprite_2d.region_rect.position.x = 320
