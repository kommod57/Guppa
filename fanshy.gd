extends Node2D
var rng = RandomNumberGenerator.new()
func _ready():
	$Grass/Area2D.hide()
	if Global.level < 21:
		queue_free()
	elif Global.level >= 21 and Global.level < 31:
		$Grass/Area2D.hide()
		color = 'grey'
		$Grass/Area2D/AnimatedSprite2D.play()
		$Grass/Area2D/AnimatedSprite2D.animation = 'grey_normal'
		$Grass.position = Vector2(0,1130)
		_make_grass(50)
	else:
		queue_free()
	
var color = 'grey'
	
	
func _make_grass(num=1,x_len=50,rng_on=true):
	var og = x_len
	for i in range(0,num):
		var mult = 1
		if rng_on:
			mult = rng.randf_range(0.5,1.5)
		var new = $Grass/Area2D.duplicate()
		new.position.x += x_len * mult
		if rng_on:
			new.position.y += mult * 10
		new.show()
		var sprite = new.get_children()[0]
		sprite.rotation_degrees = 0
		new.set_deferred("monitoring", true)
		new.connect("body_entered", Callable(self, "_on_area_body_entered").bind(sprite))
		new.connect("body_exited", Callable(self, "_on_area_body_exited").bind(sprite))
		$Grass.add_child(new)
		x_len += og
	
	
func _on_area_body_entered(body, sprite):
	if body.name == 'CharacterBody2D':
		if Global.player_dir == 1:
			if sprite.rotation_degrees == 1:
				sprite.animation = 'red_right'
			elif sprite.rotation_degrees == -1:
				sprite.animation = 'green_right'
			else:
				sprite.animation = 'grey_right'
		elif Global.player_dir == -1:
			if sprite.rotation_degrees == 1:
				sprite.animation = 'red_left'
			elif sprite.rotation_degrees == -1:
				sprite.animation = 'green_left'
			else:
				sprite.animation = 'grey_left'
		sprite.play()
	elif body.name == 'scared_guppa' or body.name == 'rigid_paint':
		if Global.scared_guppa_pos.x < sprite.position.x:
			if sprite.rotation_degrees == 1:
				sprite.animation = 'red_right'
			elif sprite.rotation_degrees == -1:
				sprite.animation = 'green_right'
			else:
				sprite.animation = 'grey_right'
		elif Global.scared_guppa_pos.x > sprite.position.x:
			if sprite.rotation_degrees == 1:
				sprite.animation = 'red_left'
			elif sprite.rotation_degrees == -1:
				sprite.animation = 'green_left'
			else:
				sprite.animation = 'grey_left'
		sprite.play()
	elif body.name == 'Sauce':
		if not Global.dangerous_particles:
			sprite.rotation_degrees = 1
			sprite.animation = 'red_right'
		else:
			sprite.rotation_degrees = -1
			sprite.animation = 'green_right'
		
		
func _on_area_body_exited(body, sprite):
	if body.name == 'CharacterBody2D' or body.name == 'scared_guppa':
		if sprite.rotation_degrees == 1:
			sprite.animation = 'red_normal'
		elif sprite.rotation_degrees == -1:
				sprite.animation = 'green_normal'
		else:
			sprite.animation = 'grey_normal'


