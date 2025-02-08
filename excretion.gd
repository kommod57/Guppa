extends Area2D  

# Called when the node enters the scene tree for the first time.
func _ready():
	if rotation_degrees == -180:
		$Sauce/despawn.wait_time = 0.5
	if rotation_degrees == -1 or rotation_degrees == -180:
		pass
	elif not Global.dangerous_particles or rotation_degrees == 1:
		$Sauce/paint/green1.hide() 
	$Sauce/despawn.start()
	#var tween = create_tween()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#
	##if position.y < 1250:
		##position.y += 980 * delta
	##else:
		##queue_free()
	#if not touching_something:
		#position.y += 980 * delta
	#else:
		#position.y -= 10 * delta


func _on_area_exited(_area):
	pass

		

func _on_despawn_timeout():
	queue_free()



var enered_scared_guppa = true

func _on_area_2d_area_entered(area):
	if rotation_degrees == -1 or rotation_degrees == -180 or Global.dangerous_particles:
		$Sauce/sizzle2.play()
	else:
		$Sauce/splish2.play()
	if area.name == 'Scared_guppa':
		
		if rotation_degrees == -1 or rotation_degrees == -180:
			$Sauce/sizzle.play()
			Global.sprite_evil_fill -= 1
		elif not Global.dangerous_particles or rotation_degrees == 1:
			Global.sprite_evil_fill += 1
			$Sauce/splish.play()
		else:
			$Sauce/sizzle.play()
			Global.sprite_evil_fill -= 1
		#queue_free()
	elif area.name == 'Gen_area_shooter':
		pass
		#queue_free()
	
