extends CharacterBody2D

const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980
var can_move = true
var first_time = true
var which_direction = -1

var grav = true
var speed_x = 50
@export var reg_speed = 100
@export var running_away_speed = 500
const GRAVITY = 980
signal hit_top

func _physics_process(_delta):
	if Global.jumpy:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
	



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.jumpy = false
	if Global.level == 0:
		queue_free()
	first_time = true
	Global.dangerous_particles = false
	can_move = true
	Global.filled = 0
	Global.sprite_evil_fill = 0
	$Scared_guppa/AnimatedSprite2D.animation = 'walk_left'
	which_direction = 1
	speed_x = reg_speed
	if Global.level == 2:
		position = Vector2(1500,1150)
	elif Global.level==3 or Global.level == 0:
		
		position = Vector2(790,1110)
		can_move = false
		speed_x = running_away_speed
	elif Global.level == 4 or Global.level == 5:
		position = Vector2(50,1110)
	elif Global.level == 9 or Global.level == 10:
		position = Vector2(1500,1110)
	elif Global.level==11:
		position = Vector2(1500,100)
	elif Global.level == 13:
		position = Vector2(100,1100)
	elif Global.level == 17:
		position.y += 500
	elif Global.level == 18:
		which_direction = -1
	elif Global.level == 19:
		position = Vector2(1550,200)
	elif Global.level == 20 and first_time and Global.natural_level_progession == 0:
		position = Vector2(600,1110)
		$Scared_guppa/AnimatedSprite2D.animation = 'walk_right'
		$Scared_guppa/AnimatedSprite2D.play()
		for i in range(20):
			await get_tree().create_timer(.05).timeout
			position.x += speed_x / 20.0
		$Scared_guppa/AnimatedSprite2D.animation = 'walk_left'
		$Scared_guppa/AnimatedSprite2D.stop()
		await get_tree().create_timer(12.5).timeout
		$splat.play()
		await get_tree().create_timer(0.5).timeout
		self.hide()
		await get_tree().create_timer(1.5).timeout
		$pop.play()
		await get_tree().create_timer(0.5).timeout
		self.show()
		first_time = false
		$Vision/scared.start()
		which_direction = -1
	elif Global.level == 20 and Global.natural_level_progession != 0:
		queue_free()

var uppy = true
func _process(delta):
	if touch_con:
		position.x += 100 * delta * convey_dir
	Global.scared_guppa_pos = position
	if Global.level == 3 and first_time:
		$Scared_guppa/AnimatedSprite2D.animation = 'blink_right'
		position.x += .5
		await get_tree().create_timer(1).timeout
		
		first_time = false
		
	_turn_around(delta)
	if Global.filled > 3:
		$Scared_guppa/AnimatedSprite2D.animation = 'fill'
		if not $Scared_guppa/AnimatedSprite2D.is_playing():
			$Scared_guppa/AnimatedSprite2D.frame = 18
			await get_tree().create_timer(1).timeout
			Global.filled = 0
			Global.level += 1
	elif Global.sprite_evil_fill < -3:
		$Scared_guppa/AnimatedSprite2D.animation = 'evil_fill'
		if not $Scared_guppa/AnimatedSprite2D.is_playing():
			$Scared_guppa/AnimatedSprite2D.frame = 18
			await get_tree().create_timer(.3).timeout
			Global.filled -= 1000
	elif Global.level == 20 and first_time:
		pass
	else:
		_vision_movement(delta)
		if speed_x > reg_speed:
			speed_x -= 5
		else:
			speed_x = reg_speed
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		#if Input.is_action_just_pressed("jump") and is_on_floor():
			#velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
	
		if (which_direction == 1 or which_direction == -1):
			
			if not $Vision/scared.is_stopped():
				velocity.x = which_direction * (speed_x / 2.0)
			else:
				velocity.x = which_direction * speed_x
		else:
			velocity.x = move_toward(velocity.x, 0, speed_x)
		move_and_slide()
					
		if not my_head:	
			if which_direction == -1:
				if $Scared_guppa/AnimatedSprite2D.animation != 'stomp' or ($Scared_guppa/AnimatedSprite2D.animation == 'stomp' and not $Scared_guppa/AnimatedSprite2D.is_playing()):
					$Scared_guppa/AnimatedSprite2D.play()
					if $Vision/scared.is_stopped():
						if Global.level != 20:
							$Scared_guppa/AnimatedSprite2D.animation = 'walk_left'
					else:
						$Scared_guppa/AnimatedSprite2D.animation = 'blink_left'
				
				if vision == 3 and (not Global.dangerous_particles and not in_danger):
					$Vision/scared.start()
					speed_x = running_away_speed
				elif vision == 4 and (not Global.dangerous_particles and not in_danger):
					vision = 0
					$Vision/scared.start()
					speed_x = running_away_speed
					which_direction = 1
				elif ((vision == -1 and Global.player_dir == 1) or vision == 3):
					speed_x = 0
					velocity.x = 0
					$Vision/scared.start()
					await get_tree().create_timer(.5).timeout
					if (vision != 0 and Global.player_dir == 1 ) or Global.dangerous_particles or in_danger:
						vision = 0
						which_direction = 1
						speed_x = running_away_speed
			elif which_direction == 1:
				if $Scared_guppa/AnimatedSprite2D.animation != 'stomp' or ($Scared_guppa/AnimatedSprite2D.animation == 'stomp' and not $Scared_guppa/AnimatedSprite2D.is_playing()):
					$Scared_guppa/AnimatedSprite2D.play()
					if $Vision/scared.is_stopped():
						if Global.level != 20:
							$Scared_guppa/AnimatedSprite2D.animation = 'walk_right'
					else:
						$Scared_guppa/AnimatedSprite2D.animation = 'blink_right'
				velocity.x = speed_x

				if vision == 4 and (not Global.dangerous_particles and not in_danger):
					$Vision/scared.start()
					speed_x = running_away_speed
				elif vision == 3 and (not Global.dangerous_particles and not in_danger):
					vision = 0
					$Vision/scared.start()
					speed_x = running_away_speed
					which_direction = -1
				elif ((vision == 1 and Global.player_dir == -1) or vision == 4):
					speed_x = 0
					velocity.x = 0
					$Vision/scared.start()
					await get_tree().create_timer(.5).timeout
					if (vision != 0 and Global.player_dir == -1 ) or Global.dangerous_particles or in_danger:
						vision = 0
						which_direction = -1
						speed_x = running_away_speed
		else:
			$Vision/scared.start()
			
			$Scared_guppa/AnimatedSprite2D.animation = 'stomp'
	
var my_head = false


var touch_con = false
var convey_dir = 0
func _on_area_2d_body_entered(body):
	if body.name == 'CharacterBody2D':
		speed_x = running_away_speed
		if Input.is_action_pressed('left'):
			which_direction = -1
		elif Input.is_action_pressed('right'):
			which_direction = 1
		else:
			if which_direction == -1:
				which_direction = 1
			else:
				which_direction = -1
	elif body.name == 'Shooter_guppa':
		Global.sprite_evil_fill -= 1
		var enemy_pos = body.position
		speed_x = running_away_speed
		if enemy_pos.x < position.x:
			which_direction = 1
		else:
			which_direction = -1
				
	if 'conveyor' in body.name:
		touch_con = true
		var child_index = -1
		var children = body.get_children()
		#var shape_owner_id = body.shape_find_owner(body_shape_index)
		# Iterate over collision shapes and check which one overlaps
		for i in range(children.size()):
			if children[i] is CollisionShape2D:
				var shape = children[i]
				# Manually check overlap using global positions
				if shape.position.distance_to(self.global_position) < 60:  # Adjust distance threshold

					child_index = i
					break 
		if children[child_index].rotation_degrees == 180:
			convey_dir = 1
		elif children[child_index].rotation_degrees == 1:
			convey_dir = 0
		elif children[child_index].rotation_degrees == 90:
			convey_dir = 0
			if which_direction == -1:
				velocity.y = JUMP_VELOCITY * 3
		elif body.get_children()[child_index].rotation_degrees == -90:
			convey_dir = 0
			if which_direction == 1:
				velocity.y = JUMP_VELOCITY * 3
			
		else:
			convey_dir = -1
		

func _vision_movement(delta):
	
	if object_cover:
		$Vision/Left_vision.position = $Scared_guppa.position
		$Vision/Right_vision.position = $Scared_guppa.position
		object_cover = false
	else:
		$Vision/Left_vision.position.x -= 500 * delta
		$Vision/Right_vision.position.x += 500 * delta
		
		


func _on_top_body_entered(_body):
	Global.head = true
	my_head = true


func _on_top_body_exited(_body):
	my_head = false
	
func _turn_around(_delta):

	if (which_direction == 1 or which_direction == -1) and Global.filled < 3 and Global.sprite_evil_fill > -3:
		var current_pos = position.x
		await get_tree().create_timer(.1).timeout
		if current_pos == position.x and Global.level != 20:
			my_head = true
			which_direction = which_direction * -1
			switch_dir = true
		if abs(current_pos - position.x) > 5:
			my_head = false

var object_cover = false
var vision = 0
func _on_left_vision_body_entered(body):
	object_cover = true
	if body.name == 'CharacterBody2D':
		vision = -1
	elif body.name == 'Shooter_guppa':
		in_danger = true
		vision = 3
var switch_dir = false

func _on_left_vision_body_exited(body):
	if (body.name == 'CharacterBody2D' or body.name == 'Shooter_guppa') and no_look:
		no_look = false
		$"Vision/not_looking at particles".start()
		my_head = false
		vision = 0
		


func _on_right_vision_body_entered(body):
	object_cover = true
	if body.name == 'CharacterBody2D':
		vision = 1
	elif body.name == 'Shooter_guppa':
		in_danger = true
		vision = 4
	
var enemy_dir = 1

func _on_right_vision_body_exited(body):
	if (body.name == 'CharacterBody2D' or body.name == 'Shooter_guppa') and no_look:
		no_look = false
		$"Vision/not_looking at particles".start()
		my_head = false
		vision = 0

var in_danger = false
func _on_left_vision_area_entered(area):
	object_cover = true
	if area.name == 'Particle':
		if area.get_parent().get_parent().rotation_degrees == -1:
			in_danger = true
		else:
			in_danger = false
		no_look = false
		$"Vision/not_looking at particles".start()
		vision = 3
	#elif area.name == 'right_paint' and not Global.dangerous_particles:
		#vision = 3
		
var no_look = false

func _on_left_vision_area_exited(area):
	if area.name == 'Particle' and no_look:
		vision = 0
		in_danger = false
	#elif area.name == 'right_paint' and not Global.dangerous_particles:
		#vision = 0

func _on_right_vision_area_entered(area):
	object_cover = true
	if area.name == 'Particle':
		if area.get_parent().get_parent().rotation_degrees == -1:
			in_danger = true
		else:
			in_danger = false
		$"Vision/not_looking at particles".start()
		
		vision = 4
	#elif area.name == 'left_paint' and not Global.dangerous_particles:
		#vision = 4



func _on_right_vision_area_exited(area):
	if area.name == 'Particle' and no_look:
		vision = 0
		in_danger = false
	#elif area.name == 'left_paint' and not Global.dangerous_particles:
		#vision = 0


func _on_not_looking_at_particles_timeout():
	no_look = true


func _on_scared_guppa_body_exited(body):
	if 'conveyor' in body.name:
		touch_con = false
