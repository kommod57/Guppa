extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var touch = false
var rng = RandomNumberGenerator.new()
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980

var rand_dist = 1

var rand_x = rng.randf_range(-.5,.5)
func _physics_process(delta):
	if touch_con:
		position.x += 100 * delta * convey_dir
	if touch:
		velocity.x = Global.player_speed * Global.player_dir * rand_dist
	else:
		velocity.x = 0
	if not is_on_floor() :
		velocity.y += gravity  * delta
		velocity.x += rand_x * 100
	
		
	move_and_slide()
	

var touch_con = false
var convey_dir = 0
func _on_area_2d_body_entered(body):
	rand_dist = rng.randf_range(1,10)
	if body.name == 'CharacterBody2D':
		touch = true
		if Global.dangerous_particles or self.get_parent().rotation_degrees == -1 or self.get_parent().rotation_degrees == -180:
			Global.filled -= 1
		elif Global.level == 0:
			Global.filled += 1
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
		touch = false
	if 'conveyor' in body.name:
		touch_con = false
