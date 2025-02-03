extends CharacterBody2D


const SPEED = 20.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	$skull_amulet.animation = 'default'
	$skull_amulet.hide()
	$AnimatedSprite2D.play()
	if Global.level > 2 and Global.level < 9:
		if Global.level == 5 or Global.level == 8:
			position += Vector2(1000,-500)
	elif Global.level == 11 or Global.level == 12:
		position = Vector2(1160,350)
	elif Global.level == 15:
		position = Vector2(700,150)
	elif Global.level == 18:
		position = Vector2(1400,100)
	elif Global.level == 19:
		pass
	elif Global.level == 20 and Global.natural_level_progession == 0.2:
		$skull_amulet.show()
		position = Vector2(1200,600)
	else:
		queue_free()

func _physics_process(delta):
	if Global.natural_level_progession == 0.3 and Global.level == 20:
		queue_free()
	if touch_con:
		position.x += 100 * delta * convey_dir
	# Add the gravity.
	if Input.is_action_pressed("special") and $AnimatedSprite2D.animation == 'move':
		$skull_amulet.animation = 'default'
		Global.jumpy = false
		velocity.x = Global.player_speed * Global.player_dir
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("down") and $AnimatedSprite2D.animation == 'move':
		$skull_amulet.animation = 'default'
		Global.jumpy = false
		velocity.x = Global.player_speed * Global.player_dir
	elif $AnimatedSprite2D.animation == 'move':
		Global.jumpy = false
		$skull_amulet.animation = 'default'
		position = Global.player_pos + Vector2(0,-35)
	elif on_guppa:
		Global.jumpy = true
		position = Global.scared_guppa_pos + Vector2(0,-35)
	elif on_shooter:
		$skull_amulet.animation = 'moving'
		position = the_shooter.position + Vector2(0,-25)
	if not is_on_floor():
		if $AnimatedSprite2D.animation == 'reg' and not on_guppa and not on_shooter:
			velocity.y += gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
var convey_dir = 1
var touch_con = false
var on_guppa = false
var shooter_pos = Vector2(0,0)

var on_shooter = false
var the_shooter = ''
func _on_box_body_entered(body):
	#if Input.is_action_pressed("jump"):
		#velocity.y = JUMP_VELOCITY
	if body.name == 'CharacterBody2D':
		$AnimatedSprite2D.animation = 'move'
	elif body.name == 'scared_guppa':
		on_guppa = true
	elif body.name == 'Shooter_guppa':
		if $skull_amulet.visible:
			on_shooter = true
			the_shooter = body
	if body.name == 'rigid_paint' and Global.dangerous_particles:
		
		$click.play()
		await get_tree().create_timer(0.1).timeout
		Global.dangerous_particles = false
		queue_free()
		#var convey_dir = 1

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
				if shape.global_position.distance_to(global_position) < 70:
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


func _on_box_body_exited(body):
	
	#velocity.x = 0
	if body.name == 'CharacterBody2D':
		$AnimatedSprite2D.animation = 'reg'
	if body.name == 'scared_guppa':
		on_guppa = false
	if body.name == 'Shooter_guppa':
		on_shooter = false
	if 'conveyor' in body.name:
		touch_con = false


func _on_box_area_entered(_area):
	#if area.name == 'skull_case' and $skull_amulet.visible:
		#$click.play()
	pass
