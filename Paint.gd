extends Area2D

var fall = false
# Called when the node enters the scene tree for the first time.
var extrection_scene: PackedScene = load('res://excretion.tscn')
signal ex_position(pos)

var how_often: float = 0.0
var speediest: float = 1.0 / 180.0
var old_level = Global.level
func _ready():
	old_level = Global.level

var switched = false
var once = true
func _process(delta):
	if Global.level == 1 and once:
		position = Vector2(724,663)
		once = false
	if Global.level == 2 and once:
		position = Vector2(824,1100)
		once = false
	if old_level != Global.level:
		old_level = Global.level
		once = true
	
	var degrees = rotation_degrees
	if abs(rotation_degrees) > 180:
		degrees = 360 - abs(rotation_degrees) 
	how_often = 1.001 - (abs(degrees) * speediest)
	$output.wait_time = how_often * 0.1
	if abs(rotation_degrees) > 360:
		rotation_degrees = abs(rotation_degrees) - 360
	if abs(rotation_degrees) > 45:
		if $output.is_stopped():
			$output.start()
	else:
		$output.stop()
	if Global.push:
		if Global.player_dir == -1:
			if switched:
				rotation_degrees = rotation_degrees * -1
				switched = false
			if Input.is_action_just_pressed('left') and not Input.is_action_pressed('special'):
				switched = true
			if Input.is_action_pressed("special"):
				rotation_degrees += -3
			position.x = Global.player_pos.x - 40
		elif Global.player_dir == 1:
			if switched:
				rotation_degrees = rotation_degrees * -1
				switched = false
			if Input.is_action_just_pressed('right') and not Input.is_action_pressed('special'):
				switched = true
			if Input.is_action_pressed("special"):
				rotation_degrees += 3
			position.x = Global.player_pos.x + 40
		
	if fall:
		if position.y < 1100:
			position.y += 980 * delta



func _on_body_entered(body):
	#var ex_instance = extrection_scene.instantiate()
	#get_tree().current_scene.add_child(ex_instance)
	
	if body.name == 'CharacterBody2D':
		
		Global.push = true
		
	if 'Object' in body.name or body.name == 'Borders':
		fall = false


func _on_body_exited(body):
	
	if 'Object' in body.name or body.name == 'Borders':
		fall = true
	if body.name == 'CharacterBody2D':
		Global.push = false


func _on_output_timeout():
	ex_position.emit($paint_stuff.global_position)
