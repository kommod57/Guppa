extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980
var start = true
var process = true
func _ready():
	$CollisionShape2D.disabled = true
	$skull/top_of_head/CollisionShape2D.disabled = true
	process = true
	$skull/base.animation = 'stand_still'
	$skull/head.animation = 'normal'
	$skull/left_arm.stop()
	$skull/right_arm.stop()
	$skull/jaw.play()
	if Global.level == 20:
		start = false
		self.modulate.a = 0
		position = Vector2(1200,1000)
		#await Global.natural_level_progession == 1
		if Global.natural_level_progession == 1:
			$scare.play()
			await get_tree().create_timer(1).timeout
			for i in range(0,3):
				self.modulate.a += 0.05
				await get_tree().create_timer(0.05).timeout
			for i in range(0,3):
				self.modulate.a -= 0.05
				await get_tree().create_timer(0.05).timeout
			queue_free()
			Global.level += 1
	else:
		queue_free()
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and start:
		velocity.y += gravity * delta
	elif start:
		if process:
			_mouth(true,false)

	
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

func _mouth(open=true, close=true):
	process = false
	if $skull/jaw.position.y == 0 and open:
		for i in range(1,10):
			await get_tree().create_timer(0.01).timeout
			$skull/jaw.position.y += 2
	if $skull/jaw.position.y != 0 and close:
		for i in range(1,10):
			await get_tree().create_timer(0.01).timeout
			$skull/jaw.position.y -= 2
		process = true

		
