extends Node2D

@export var start_screen: PackedScene = load("res://start_screen.tscn")

var level1 = load('res://level_1.tscn')
var ex_scene = load('res://excretion.tscn')
var rng = RandomNumberGenerator.new()
func _ready():
	if Global.level == 20 and Global.natural_level_progession > 0.1:
		$green_back.show()
	else:
		$green_back.hide()
	if Global.level % 10 != 0:
		Global.natural_level_progession = 0
	$Borders/Ceiling.disabled = true
	$Borders/Ceiling/ColorRect.hide()
	Global.music_player2.stop()
	if Global.level != 8:
		Global.lever_on = false
	Global.push = false
var once = true
var old_level = 0
func _process(_delta):
	if once:
		old_level = Global.level
		once = false
	if Input.is_action_just_pressed("retry") or Global.level != old_level or Global.filled <= -1000:
		once = true
		retry_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_packed(start_screen)
	if Global.level == 20:
		if Global.natural_level_progession == 0:
			Global.music_player1.stop()
		elif Global.natural_level_progession >= 0.2:
			if not Global.boss1.is_playing():
				Global.boss1.play()
		
		if Global.natural_level_progession == 0.1:
			Global.natural_level_progession = 0.2
			retry_scene()
	else:
		
		if not Global.music_player1.is_playing():
			Global.music_player1.play()
		
func retry_scene():
	# Get the current scene
	if get_tree().current_scene:
		#var current_scene = get_tree().current_scene
	
		# Reload the current scene
		get_tree().reload_current_scene()



#func _on_paint_ex_position(pos):
	#var ex = ex_scene.instantiate()
	#
	#var move_x = rng.randi_range(-50,50)
	#ex.position = pos
	#ex.position.x += move_x
	#$exs.add_child(ex)


func _on_paint_char_ex_position(pos):
	if not Global.empty_bucket:
		var ex = ex_scene.instantiate()
		var move_x = rng.randi_range(-50,50)
		ex.position = pos
		ex.position.x += move_x
		$exs.add_child(ex)
	
	
	

	



func _on_rigid_paint_x_position(pos):
	if not Global.empty_bucket:
		var ex = ex_scene.instantiate()
		var move_x = rng.randi_range(-50,50)
		ex.position = pos
		ex.position.x += move_x
		$exs.add_child(ex)
