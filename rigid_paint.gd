extends RigidBody2D
var gravity = 980

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.empty_bucket = false
	once = true
	first_time = true
	if Global.level == 9 or Global.level == 10:
		position = Vector2(724,200)
		
	if Global.level == 1:
		position = Vector2(724,663)
	if Global.level == 2:
		position = Vector2(1300,900)
	if ((Global.level > 2 and Global.level < 9) or Global.level == 0):
		if Global.level != 0:
			Global.dangerous_particles = true
		position = Vector2(824,100)
		
		$AnimatedSprite2D.rotation_degrees = 180
		$pivot.rotation_degrees = 180
		if Global.level == 4:
			$AnimatedSprite2D.rotation_degrees = 90
			$pivot.rotation_degrees = 90
		elif Global.level == 5:
			$AnimatedSprite2D.rotation_degrees = -90
			$pivot.rotation_degrees = -90
			position.y += 500
			position.x += 100
		elif Global.level == 6:
			$AnimatedSprite2D.rotation_degrees = 0
			$pivot.rotation_degrees = 0
		elif Global.level == 7:
			position.y += 300
		elif Global.level == 8:
			Global.lever_on = true
	elif Global.level == 11:
		position = Vector2(724,663)
		#Global.dangerous_particles = true
	elif Global.level == 12:
		position = Vector2(724,663)
		Global.dangerous_particles = true
	elif Global.level == 13:
		position = Vector2(724,100)
		#Global.dangerous_particles = true
		$AnimatedSprite2D.rotation_degrees = -180
		$pivot.rotation_degrees = -180
	elif Global.level == 14:
		position = Vector2(723,500)
	elif Global.level == 15:
		position = Vector2(1180,1000)
		Global.dangerous_particles = true
		$AnimatedSprite2D.rotation_degrees = 90
		$pivot.rotation_degrees = 90
	elif Global.level == 16:
		queue_free()
	elif Global.level == 18:
		Global.dangerous_particles = true
	elif Global.level == 19:
		Global.dangerous_particles = true
		$AnimatedSprite2D.rotation_degrees = 90
		$pivot.rotation_degrees = 90
	elif Global.level == 20 and Global.natural_level_progession==0:
		
		Global.empty_bucket = true
		position = Vector2(724,-20)
		$AnimatedSprite2D.rotation_degrees = 15
		$pivot.rotation_degrees = 15
	elif Global.level == 20:
		queue_free()

		

func _physics_process(delta):
	if touch_con:
		position.x += 100 * delta * convey_dir
	$Paint.rotation = -rotation
	$One_way_collision.rotation = -rotation
	if is_on_floor():
		apply_torque_impulse(50)
		#$AnimatedSprite2D.rotation_degrees = rotation_degrees
		#$pivot.rotation_degrees = rotation_degrees
	else:
		linear_velocity.y += gravity * delta
	if direction != 0:
		if Input.is_action_pressed("down"):
			linear_velocity.x = direction * Global.player_speed * 2
		else:
			linear_velocity.x = direction * Global.player_speed / 2
	else:
		#velocity.x = move_toward(velocity.x, 0, Global.player_speed)
		linear_velocity.x = 0
	if (Input.is_action_just_released("left") or Input.is_action_just_released("right")):
			direction = 0
			linear_velocity.x = 0
			dont_move = true
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		dont_move = false
		
		# Check if on edge (platform normal is close to horizontal)
		#if abs(platform.x) > 0.8:
			#apply_torque_impulse(100 * platform.x)  # Apply rotation force
# Called every frame. 'delta' is the elapsed time since the previous frame.
func is_on_floor():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0,10))
	var result = space_state.intersect_ray(query)
	
	return result.size() > 0

var switched = false
var once = true
var rot_degs = 0

var first_time = true

var direction = 0
var extrection_scene: PackedScene = load('res://excretion.tscn')
signal x_position(pos)

var how_often: float = 0.0
var speediest: float = 1.0 / 180.0
var old_level = Global.level

func _process(delta):
	
	if Global.dangerous_particles:
		$AnimatedSprite2D.animation = 'd_bucket_evil'
		$Paint/flowa.hide()
	elif Global.empty_bucket:
		$AnimatedSprite2D.animation = 'empty'
		$Paint/flowa.hide()
	else:
		$AnimatedSprite2D.animation = 'd_bucket'
		if Global.level != 10:
			$Paint/flowa.show()
	rot_degs = $AnimatedSprite2D.rotation_degrees
	$pivot.rotation_degrees = rot_degs
	#$flowa.rotation_degrees = rot_degs
	
	
	var degrees = $AnimatedSprite2D.rotation_degrees
	if abs($AnimatedSprite2D.rotation_degrees) > 180:
		degrees = 360 - abs($AnimatedSprite2D.rotation_degrees) 
	how_often = 1.001 - (abs(degrees) * speediest)
	$Paint/output.wait_time = how_often * 0.1
	if abs($AnimatedSprite2D.rotation_degrees) > 360:
		$AnimatedSprite2D.rotation_degrees = abs($AnimatedSprite2D.rotation_degrees) - 360
	if abs($AnimatedSprite2D.rotation_degrees) > 45 or (abs(rotation_degrees) > 45 and first_time):
		
		if $Paint/output.is_stopped():
			$Paint/output.start()
		if abs($AnimatedSprite2D.rotation_degrees) > 45:
			first_time = false
	else:
		$Paint/output.stop()
	if Global.level == 8:
		if Global.lever_on:
			$AnimatedSprite2D.rotation_degrees -= 600 * delta
			direction = 0
			if position.y > 100:
				linear_velocity.y = -500
			else:
				linear_velocity.y = 0
	if Global.level == 18:
		if not Global.dangerous_particles:
			$AnimatedSprite2D.rotation_degrees += 5
			$pivot.rotation_degrees += 5
	
	if Global.level == 20:
		if once:
			#$AnimatedSprite2D.hide()
			linear_velocity.y = -50
			await get_tree().create_timer(13).timeout
			once = false
		else:
			$AnimatedSprite2D.show()
			
		
			
	if Global.push:
		if Input.is_action_pressed("down"):
			direction = Global.player_dir * -1
		elif right_side:
			if Input.is_action_pressed("special"):
				$AnimatedSprite2D.rotation_degrees -= 300 * delta
				direction = 0
				#dont_move = true
			#elif Input.is_action_pressed("down"):
				#$Paint/AnimatedSprite2D.rotation_degrees += 300 * delta
				#direction = 0
			elif Global.player_dir == -1:
				if not dont_move:
					direction = -1
			else:
				direction = 0
		else:
			if Input.is_action_pressed("special"):
				$AnimatedSprite2D.rotation_degrees += 300 * delta
				direction = 0
				#dont_move = true
			#elif Input.is_action_pressed("down"):
				#$Paint/AnimatedSprite2D.rotation_degrees -= 300 * delta
				#direction = 0
			elif Global.player_dir == 1:
				if not dont_move:
					direction = 1
			else:
				direction = 0



func _on_output_timeout():
	x_position.emit($pivot/paint_stuff.global_position)
	
var dont_move = false
var right_side = false


func _on_left_paint_body_entered(body):
	if body.name == 'CharacterBody2D':
		dont_move = false
		Global.push = true
		right_side = false


func _on_right_paint_body_entered(body):
	if body.name == 'CharacterBody2D':
		dont_move = false
		Global.push = true
		right_side = true


func _on_left_paint_body_exited(body):
	if body.name == 'CharacterBody2D':
		Global.push = false
		direction = 0


func _on_right_paint_body_exited(body):
	if body.name == 'CharacterBody2D':
		Global.push = false
		direction = 0
var touch_con = false
var convey_dir = 0

func _on_paint_body_entered(body):
	if 'conveyor' in body.name:
		touch_con = true
		if body.get_children()[0].rotation_degrees == 180:
			convey_dir = 1
		elif body.get_children()[0].rotation_degrees == 1:
			convey_dir = 0
		else:
			convey_dir = -1.


func _on_paint_body_exited(body):
	if 'conveyor' in body.name:
		touch_con = false
