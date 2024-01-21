extends Ghost


func _physics_process(_delta):
	
	if energy_bar.value <= 0:
		energy_bar.visible = false
	else:
		energy_bar.visible = true
		
	if taking_damage:
		pass
	else:
		adjust_energy(regen_rate)

	
	if player_to_attack != null:

		direction = global_position.direction_to(player_to_attack.global_position)
		if direction.x > 0:
			sprite_2d.flip_h = true
			float_particle.position.x *= -1
		elif direction.x < 0:
			sprite_2d.flip_h = false
			float_particle.position.x *= -1
		
		
		if !immobile:
			velocity = direction * SPEED
		
	elif Globals.currentPlayer != null:
		player_to_attack = Globals.currentPlayer

	move_and_slide()
	match_states()

func adjust_energy(adjustment):
	energy_bar.value += adjustment
	sprite_2d.scale = Vector2(1,1) * (1 + energy_bar.value / 600.0)
	sprite2d_shader.set_shader_parameter("intensity", energy_bar.value / 650.0)
	if energy_bar.value / energy_bar.max_value >= 0.8:
		sprite_2d.region_rect.position.x = startingRectX + sprite_2d.region_rect.size.x
	else:
		sprite_2d.region_rect.position.x = startingRectX
		sprite_2d.region_rect.position.y = startingRectY


