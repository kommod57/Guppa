extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var keep_going = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var direction = 1
var gravity = 980
func _ready():
	first_time = false
	if Global.level == 20 and Global.natural_level_progession == 0.2:
		$metalic.play()
		position = Vector2(600,770)
		first_time = true
		$AnimatedSprite2D.animation = 'excited_fill'
		$AnimatedSprite2D.play()
		
	elif Global.level == 13:
		position = Vector2(700,300)
	elif Global.level == 15:
		position = Vector2(500,1100)
	elif Global.level == 20 and Global.natural_level_progession >= 0.3:
		position = Vector2(600,770)
	else:
		queue_free()
var update = true
var touch_con = false
var convey_dir = 0
var first_time = false

var current_dir = 1
func _physics_process(delta):
	if first_time:
		if not $AnimatedSprite2D.is_playing():
			first_time = false
	if not first_time:
		$AnimatedSprite2D.play()
		if touch_con:
			position.x += 100 * delta * convey_dir
		if update:
			if direction != 0:
				keep_going = direction * -1
			update = false
		_turn_around(delta)
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		if direction == 1 or direction == -1:
			current_dir = direction
			$vision.position.x += 20 * keep_going
			if direction == 1:
				$AnimatedSprite2D.animation = 'right'
			else:
				$AnimatedSprite2D.animation = 'left'
				
			if special_powers:
				velocity.x = direction * SPEED * 3
			else:
				velocity.x = direction * SPEED
		else:
			$vision.position.x = 0
			$AnimatedSprite2D.animation = 'stopped'
			var spec = 1
			if special_powers:
				spec = 3
			velocity.x = move_toward(velocity.x, 0, SPEED * spec)
			#await get_tree().create_timer(0.5).timeout
			direction = current_dir 
				
		
		
		if $vision.global_position.x > 1650 or $vision.global_position.x < -50:
			$vision.position.x = 0
		if $shots.global_position.x > 1650 or $shots.global_position.x < -50:
			$shots.position.x = 0

		move_and_slide()
	
func _turn_around(_delta):
	if (direction == 1 or direction == -1) and Global.filled < 3 and Global.sprite_evil_fill > -3:
		var current_pos = position
		await get_tree().create_timer(.1).timeout
		if current_pos == position:
			direction = direction * -1
			#if special_powers:
				#velocity.y = JUMP_VELOCITY * 1.5
			#else:
				#velocity.y = JUMP_VELOCITY
			


func _on_vision_body_entered(body):
	if body.name == 'CharacterBody2D' and $vision/see_guppa.is_stopped():
		$vision/see_guppa.start()
		direction = direction * -1
		if special_powers:
			velocity.y = JUMP_VELOCITY * 1.5
		else:
			velocity.y = JUMP_VELOCITY
		
	$vision.position.x = 0
	update = true


func _on_vision_area_entered(_area):
	pass

var special_powers = false
func _on_top_of_head_body_entered(body):
	if body.name == 'CharacterBody2D':
		direction = 0
	if body.name == 'Flowa':
		direction = 0
		special_powers = true
		
func _on_top_of_head_body_exited(body):
	if body.name == 'Flowa':
		special_powers = false


func _on_gen_area_body_entered(body):
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
			if direction == -1:
				velocity.y = JUMP_VELOCITY * 3
		elif body.get_children()[child_index].rotation_degrees == -90:
			convey_dir = 0
			if direction == 1:
				velocity.y = JUMP_VELOCITY * 3
			
		else:
			convey_dir = -1


func _on_gen_area_body_exited(body):
	if 'conveyor' in body.name:
		touch_con = false
