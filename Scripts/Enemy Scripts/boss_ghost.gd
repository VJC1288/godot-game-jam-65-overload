extends Ghost


func adjust_energy(adjustment):
	energy_bar.value += adjustment
	sprite_2d.scale = Vector2(1,1) * (1 + energy_bar.value / 900.0)
	sprite2d_shader.set_shader_parameter("intensity", energy_bar.value / 650.0)
	if energy_bar.value / energy_bar.max_value >= 0.8:
		sprite_2d.region_rect.position.x = startingRectX + sprite_2d.region_rect.size.x
	else:
		sprite_2d.region_rect.position.x = startingRectX
		sprite_2d.region_rect.position.y = startingRectY
