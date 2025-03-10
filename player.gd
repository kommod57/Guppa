extends CharacterBody2D

func _ready():
	if Global.level == 0:
		current_animation = 'fill_urself'
		$char_animation.stop()
	position = Vector2(200, 1110)
	$char_animation.animation = current_animation
	if Global.level == 8:
		position = Vector2(1200, 1110)
	elif Global.level == 19:
		position.y -= 800

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const SHORT_JUMP_MULTIPLIER = 0.5
const FLOOR_NORMAL = Vector2.UP

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980
var rng = RandomNumberGenerator.new()
var current_animation = 'walk_right'
var phantom = false
var fall = true
var touch_enemy = false
var enememy_dir = 1
var is_jumping = false
func _physics_process(delta):
	if Global.level == 20 and Global.natural_level_progession == 0:
		if position.y < 0:
			Global.natural_level_progession = 0.1
	if touch_con:
		position.x += 100 * delta * convey_dir
		if up:
			position.y -= 200 * delta
	# Add the gravity.
	Global.player_pos = position
	if not is_on_floor():
		if phantom and velocity.y > -1:
			fall = false
			$phantom_jumping.start()
			phantom = false
		if not up:
			velocity.y += gravity * delta
	else:
		phantom = true
	if Global.filled < -10 and Global.filled > -1000:
		if not $metalic.is_playing():
			$metalic.play()
		velocity.x = 0
		
		$char_animation.animation = 'turn_evil'
		if not $char_animation.is_playing():
			$char_animation.frame = 18
			
			await get_tree().create_timer(.3).timeout
			Global.filled -= 1000
	elif Global.level == 0 and Global.filled > 3:
		$char_animation.animation = 'fill_urself'
		if velocity.x != 0:
			$char_animation.play()
		velocity.x = 0
		if not $char_animation.is_playing():
			$char_animation.frame = 19
			await get_tree().create_timer(1).timeout
			print('level finished')
			Global.filled = 0
			Global.level += 1
	else:
		# Handle jump.
		if (Input.is_action_pressed("jump") and (not fall or phantom)) or Global.head:
			phantom = false
			if Global.head:
				$bounce.play()
				await get_tree().create_timer(0.1).timeout
				
				velocity.y = JUMP_VELOCITY
			else:
				if Global.level != 0:
					is_jumping = true
					velocity.y = JUMP_VELOCITY
			Global.head = false
		if is_jumping and Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= SHORT_JUMP_MULTIPLIER  # Apply a smaller velocity when released
			is_jumping = false
			
		# Get the input directi\on and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		
		if direction:
			if not Input.is_action_pressed("down"):
				Global.player_dir = direction
			if direction == 1:
				if Global.level != 0:
					if current_animation != 'hit':
						current_animation = 'walk_right'
				else:
					current_animation = 'g_walk_right'
				if current_animation == 'hit' and not $char_animation.is_playing():
					current_animation = 'walk_right'
				$char_animation.animation = current_animation
			elif direction == -1:
				if Global.level != 0:
					if current_animation != 'hit':
						current_animation = 'walk_left'
				else:
					current_animation = 'g_walk_left'
				if current_animation == 'hit' and not $char_animation.is_playing():
					current_animation = 'walk_left'
				$char_animation.animation = current_animation
			if current_animation != 'hit':
				$char_animation.play()
			if touch_enemy:
				current_animation = 'hit'
				$char_animation.play()
				Global.player_speed = SPEED * 5
				velocity.x = enememy_dir * SPEED * 5
				velocity.y = JUMP_VELOCITY * 0.5
			elif Input.is_action_pressed("down") and Global.push:
				Global.player_speed = SPEED / 2
				velocity.x = direction * SPEED / 2
			else:
				Global.player_speed = SPEED
				velocity.x = direction * SPEED
		else:
			var blink = 1
			if Global.level != 0:
				blink = rng.randi_range(0,500)
			if blink == 0:
				$char_animation.animation = 'blink'
				$char_animation.play()
				
			else:
				if $char_animation.animation != 'blink' and $char_animation.animation != 'hit':
					$char_animation.stop()
				if not $char_animation.is_playing():
					blink = 1
					$char_animation.animation = current_animation
					$char_animation.stop()
			if touch_enemy:
				current_animation = 'hit'
				$char_animation.animation = 'hit'
				$char_animation.play()
				Global.player_speed = SPEED * 5
				velocity.y = JUMP_VELOCITY * 0.5
				velocity.x = enememy_dir * SPEED * 5
			elif Global.push or Input.is_action_just_pressed("down"):
		
				velocity.x = move_toward(velocity.x, 0, SPEED/2)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				
	move_and_slide()

var convey_dir = 1
var touch_con = false


func _on_to_move_me_body_entered(body):
	if body.name == 'Flowa':
		if body.get_children()[3].visible:
			#await get_tree().create_timer(0.05).timeout
			await get_tree().create_timer(0.01).timeout
			velocity.y = JUMP_VELOCITY
	if 'Shooter_guppa' == body.name:
		$To_move_me/hit.play()
		Global.filled -= 5
		if body.position.x > position.x:
			enememy_dir = -1
		else:
			enememy_dir = 1
		touch_enemy = true
			
	if 'conveyor' in body.name:
		#var body_shape_index = 0
		touch_con = true
		var child_index = -1
		var children = body.get_children()
		#var shape_owner_id = body.shape_find_owner(body_shape_index)
		# Iterate over collision shapes and check which one overlaps
		for i in range(children.size()):
			if children[i] is CollisionShape2D:
				var shape = children[i]
				
				# Manually check overlap using global positions
				if shape.global_position.distance_to(self.global_position) < 50:  # Adjust distance threshold
					child_index = i
					break 
		if children[child_index].rotation_degrees == 180:
			convey_dir = 1
		elif children[child_index].rotation_degrees == 1:
			convey_dir = 0
		elif children[child_index].rotation_degrees == 90:
			
			#convey_dir = -1
			convey_dir = 0
			if Global.player_dir == -1:
				velocity.y = JUMP_VELOCITY
				up = true
				
		elif body.get_children()[child_index].rotation_degrees == -90:
			#convey_dir = 1
			convey_dir = 0
			if Global.player_dir == 1:
				velocity.y = JUMP_VELOCITY
				up = true
				
			
		else:
			convey_dir = -1
			
	if body.name == 'con_top':
		touch_con = true
		convey_dir = -1
	if body.name == 'con_top2':
		touch_con = true
		convey_dir = 1


func _on_phantom_jumping_timeout():
	fall = true

var up = false
func _on_to_move_me_body_exited(body):
	if 'conveyor' in body.name:
		touch_con = false
		up = false
	if 'Shooter_guppa' == body.name:
		touch_enemy = false
	if body.name == 'con_top':
		touch_con = false
	if body.name == 'con_top2':
		touch_con = false
		



func _on_to_move_me_area_entered(_area):
	pass
	#if area.name == 'Top_of_head':
		#$bounce.play()
		##await get_tree().create_timer(0.1).timeout
		#
		#velocity.y = JUMP_VELOCITY -200
