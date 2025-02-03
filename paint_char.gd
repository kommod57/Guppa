extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
var extrection_scene: PackedScene = load('res://excretion.tscn')
signal ex_position(pos)

var how_often: float = 0.0
var speediest: float = 1.0 / 180.0
var old_level = Global.level
func _ready():
	rotation_degrees = 0
	if Global.level == 9:
		queue_free()


#const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980

var direction = 0
func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if direction != 0:
		if Input.is_action_pressed("down"):
			velocity.x = direction * Global.player_speed
		else:
			velocity.x = direction * Global.player_speed / 2
	else:
		#velocity.x = move_toward(velocity.x, 0, Global.player_speed)
		velocity.x = 0
	if (Input.is_action_just_released("left") or Input.is_action_just_released("right")):
			direction = 0
			velocity.x = 0
			dont_move = true
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		dont_move = false
	else:
		move_and_slide()
	
	
var switched = false
var once = true
var rot_degs = 0
func _process(delta):
	if Global.dangerous_particles:
		$Paint/AnimatedSprite2D.animation = 'd_bucket_evil'
		$flowa.hide()
	else:
		$Paint/AnimatedSprite2D.animation = 'd_bucket'
		$flowa.show()
	rot_degs = $Paint/AnimatedSprite2D.rotation_degrees
	$Paint/pivot.rotation_degrees = rot_degs
	#$flowa.rotation_degrees = rot_degs
	if Global.level == 1 and once:
		position = Vector2(724,663)
		once = false
	if Global.level == 2 and once:
		position = Vector2(824,1100)
		once = false
	if ((Global.level > 2 and Global.level < 9) or Global.level == 0) and once:
		if Global.level != 0:
			Global.dangerous_particles = true
		position = Vector2(824,100)
		once = false
		
		$Paint/AnimatedSprite2D.rotation_degrees = 180
		$Paint/pivot.rotation_degrees = 180
		if Global.level == 4:
			$Paint/AnimatedSprite2D.rotation_degrees = 90
			$Paint/pivot.rotation_degrees = 90
		elif Global.level == 5:
			$Paint/AnimatedSprite2D.rotation_degrees = -50
			$Paint/pivot.rotation_degrees = -50
		elif Global.level == 6:
			$Paint/AnimatedSprite2D.rotation_degrees = 0
			$Paint/pivot.rotation_degrees = 0
		elif Global.level == 8:
			Global.lever_on = true
	elif Global.level == 9 and once:
		self.hide()
		position = Vector2(724,200)
		once = false
	if old_level != Global.level:
		old_level = Global.level
		once = true
	
	var degrees = $Paint/AnimatedSprite2D.rotation_degrees
	if abs($Paint/AnimatedSprite2D.rotation_degrees) > 180:
		degrees = 360 - abs($Paint/AnimatedSprite2D.rotation_degrees) 
	how_often = 1.001 - (abs(degrees) * speediest)
	$Paint/output.wait_time = how_often * 0.1
	if abs($Paint/AnimatedSprite2D.rotation_degrees) > 360:
		$Paint/AnimatedSprite2D.rotation_degrees = abs($Paint/AnimatedSprite2D.rotation_degrees) - 360
	if abs($Paint/AnimatedSprite2D.rotation_degrees) > 45:
		if $Paint/output.is_stopped():
			$Paint/output.start()
	else:
		$Paint/output.stop()
	if Global.level == 8:
		if Global.lever_on:
			$Paint/AnimatedSprite2D.rotation_degrees -= 600 * delta
			direction = 0
			velocity.y -= 400
	if Global.push:
		if Input.is_action_pressed("down"):
			direction = Global.player_dir * -1
		elif right_side:
			if Input.is_action_pressed("special"):
				$Paint/AnimatedSprite2D.rotation_degrees -= 300 * delta
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
				$Paint/AnimatedSprite2D.rotation_degrees += 300 * delta
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
	ex_position.emit($Paint/pivot/paint_stuff.global_position)


var dont_move = false
var right_side = false
func _on_left_body_entered(body):
	if body.name == 'CharacterBody2D':
		dont_move = false
		Global.push = true
		right_side = false
		


func _on_right_body_entered(body):
	if body.name == 'CharacterBody2D':
		dont_move = false
		Global.push = true
		right_side = true


func _on_left_body_exited(body):
	if body.name == 'CharacterBody2D':
		Global.push = false
		direction = 0


func _on_right_body_exited(body):
	if body.name == 'CharacterBody2D':
		Global.push = false
		direction = 0
