extends Area2D


var velocity = Vector2.ZERO
const GRAVITY = 980
signal hit_top


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.filled = 0
	$AnimatedSprite2D.animation = 'walk_left'
	which_direction = 1
	speed_x = reg_speed

var grav = true
var which_direction = 1
var speed_x = 20 
@export var reg_speed = 30
@export var running_away_speed = 500

var uppy = true
func _process(delta):
	if Global.filled > 3:
		pass
		#$AnimatedSprite2D.animation = 'fill'
		#if not $AnimatedSprite2D.is_playing():
			#$AnimatedSprite2D.frame = 18
			#await get_tree().create_timer(1).timeout
			#print('level finished')
			#Global.filled = 0
			#Global.level += 1
	else:
		# Move the Area2D manually
		position += velocity * delta
		
		# Apply gravity
		
		if grav:
			velocity.y += GRAVITY * delta
		# Check for collision with the floor
		if is_colliding_with_floor():
			if uppy:
				position.y -= velocity.y/25
				uppy = false
			elif touching_object:
				position.y -= 1
			$on_ground.start()
			grav = false
			velocity.y = 0  # Stop falling
			

		if speed_x > reg_speed:
			speed_x -= 5
		else:
			speed_x = reg_speed
		if not my_head:	
			$AnimatedSprite2D.play()
			
			if which_direction == 0:
				$AnimatedSprite2D.animation = 'walk_left'
				velocity.x = speed_x * -1
				if Global.player_pos[0] < position.x - 50 and (Global.player_pos[1] - 50 < position.y  and Global.player_pos[1] + 50 > position.y ) and Global.player_dir == 1:
					speed_x = 0
					velocity.x = 0
					$AnimatedSprite2D.animation = 'blink_left'
					await get_tree().create_timer(.5).timeout
					if Global.player_dir == 1 and (Global.player_pos[1] - 50 < position.y  and Global.player_pos[1] + 50 > position.y ):
						which_direction = 1
						speed_x = running_away_speed
					else:
						speed_x = reg_speed
			elif which_direction == 1:
				$AnimatedSprite2D.animation = 'walk_right'
				velocity.x = speed_x
				if Global.player_pos[0] > position.x + 50 and (Global.player_pos[1] - 50 < position.y and Global.player_pos[1] + 50 > position.y) and Global.player_dir == -1:
					speed_x = 0
					velocity.x = 0
					$AnimatedSprite2D.animation = 'blink_right'
					await get_tree().create_timer(.5).timeout
					if Global.player_dir == -1 and (Global.player_pos[1] - 50 < position.y  and Global.player_pos[1] + 50 > position.y ):
						which_direction = 0
						speed_x = running_away_speed
					else:
						speed_x = reg_speed
			if position.x > 1550:
				which_direction = 0
			elif position.x < 50:
				which_direction = 1
		else:
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.animation = 'stomp'
var touching_object = false

func is_colliding_with_floor() -> bool:
	
	for body in get_overlapping_bodies():
		if body.name == 'Borders':  # Assuming our floor is in the "floor" group
			
			return true
		elif 'Object' in body.name:  # Assuming our floor is in the "floor" group
			touching_object = true
			return true
			
	return false


func _on_body_entered(body):
	
	if body.name == 'CharacterBody2D':
		speed_x = running_away_speed
		if Input.is_action_pressed('left'):
			which_direction = 0
		elif Input.is_action_pressed('right'):
			which_direction = 1
		else:
			if which_direction == 0:
				which_direction = 1
			else:
				which_direction = 0
	if 'Object' in body.name:
		touching_object = true
		#if which_direction == 0:
			#which_direction = 1
		#else:
			#which_direction = 0
		grav = false
				


func _on_body_exited(body):
	if 'Object' in body.name:
		touching_object = false
	grav = true
	pass
	
	
var my_head = false

func _on_area_2d_body_entered(body):
	Global.head = true
	my_head = true
	
	
	


func _on_area_2d_body_exited(body):
	my_head = false


func _on_on_ground_timeout():

	grav = true
	uppy = true
