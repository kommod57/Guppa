extends CharacterBody2D


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980
var player_in_area = false
func _ready():
	
	$lever_anim.animation = 'off'
	if Global.level == 8:
		$lever_anim.animation = 'on'
	
	if Global.level == 2:
		pass
	elif Global.level == 6:
		position = Vector2(1000,1100)
	elif Global.level == 8:
		position = Vector2(1550,100)
	elif Global.level == 9:
		position = Vector2(1400,1110)
	elif Global.level == 11:
		position = Vector2(1550,150)
		
	elif Global.level == 13:
		position = Vector2(1160,600)
	elif Global.level == 16:
		pass
	elif Global.level == 17:
		position = Vector2(900,1110)
	elif Global.level == 18:
		position = Vector2(650,1110)
	elif Global.level == 19:
		position = Vector2(1420,0)
	else:
		queue_free()

var local_lever_on = false
func _physics_process(delta):
	if touch_con:
		position.x += 100 * delta * convey_dir
	if Global.lever_on != local_lever_on:
		$click.play()
	if Global.lever_on:
		local_lever_on = true
		$lever_anim.animation = 'on'
	else:
		local_lever_on = false
		$lever_anim.animation = 'off'
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
var once = false
func _process(_delta):
	if player_in_area:
		if Input.is_action_just_pressed("special"):
			
			if $lever_anim.animation == 'off':
				$lever_anim.animation = 'on'
				Global.lever_on = true
			else:
				$lever_anim.animation = 'off'
				Global.lever_on = false
		if Input.is_action_pressed("down"):
			velocity.x = Global.player_speed * Global.player_dir * -1
	else:
		velocity.x = 0

		

var convey_dir = 1
var touch_con = false
var on_guppa = false

func _on_area_2d_body_entered(body):

	if body.name == 'CharacterBody2D':
		player_in_area = true
	#else:
		#print(body.name)
	if body.name == 'scared_guppa':
		if Global.lever_on:
			Global.lever_on = false
		else:
			Global.lever_on = true
	if body.name == 'Shooter_guppa':
		if Global.lever_on:
			Global.lever_on = false
		else:
			Global.lever_on = true
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
			convey_dir = -1
			#if which_direction == -1:
				#velocity.y = JUMP_VELOCITY
		elif body.get_children()[child_index].rotation_degrees == -90:
			convey_dir = 1
			#if which_direction == 1:
				#velocity.y = JUMP_VELOCITY
			
		else:
			convey_dir = -1
	
		


func _on_area_2d_body_exited(body):
	if body.name == 'CharacterBody2D':
		player_in_area = false
	if 'conveyor' in body.name:
		touch_con = false
