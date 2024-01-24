extends Ghost

signal boss_died

func adjust_energy(adjustment):
	energy_bar.value += adjustment
	sprite_2d.scale = Vector2(1,1) * (1 + energy_bar.value / 900.0)
	sprite2d_shader.set_shader_parameter("intensity", energy_bar.value / 650.0)
	if energy_bar.value / energy_bar.max_value >= 0.8:
		sprite_2d.region_rect.position.x = startingRectX + sprite_2d.region_rect.size.x
	else:
		sprite_2d.region_rect.position.x = startingRectX
		sprite_2d.region_rect.position.y = startingRectY

func kill_ghost():
		deathState = true
		emit_signal("ghost_died", global_position, ghost_type)
		emit_signal("boss_died")
		if death_scene != null:
			death_effect()
		Globals.currentTargetedGhost = null
		Globals.currentPlayer.clear_beams()
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)
		float_particle.visible = false
		shadow.visible = false
		sprite_2d.visible = false
		panel.visible = false
		box_container.visible = false		
		death_sound.play()
		await death_sound.finished
		queue_free()
