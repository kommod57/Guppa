extends Node2D

@export var start_screen: PackedScene = load("res://start_screen.tscn")

var level1 = load('res://level_1.tscn')
var ex_scene = load('res://excretion.tscn')
var rng = RandomNumberGenerator.new()
func _ready():
	$back_objects/hills.hide()
	$back_objects/hills.position.x = 1014 - (Global.level * 10)
	cloud_speed = rng.randi_range(20,100)
	for cloud in $back_objects/clouds.get_children():
		cloud.position.x = randi_range(-2400,0)
		cloud.position.y = randi_range(50,1000)
		cloud.frame = randi_range(0,54)
		cloud.hide()
	old_level = Global.level
	once = false
	
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
	if not $green_back.visible:
		$back_objects/hills.show()
		for cloud in $back_objects/clouds.get_children():
			cloud.show()
		if not Global.player_death:

			Global.tree_positions = []
			for tree in $back_objects/trees.get_children():
				var show_up = rng.randi_range(0,1)
				if show_up == 1:
					tree.position = Vector2(rng.randi_range(1,1600), rng.randi_range(790,810))
					Global.tree_positions.append(tree.position)
				else:
					Global.tree_positions.append(Vector2(0,0))
		else:
			var trees = $back_objects/trees.get_children()
			for i in range(trees.size()):
				var tree = trees[i]
				tree.position = Global.tree_positions[i]
			
	for tree in $back_objects/trees.get_children():
		if tree.position == Vector2(0,0):
			tree.hide()
		else:
			tree.show()
				
	
	
var once = true
var old_level = 0
var cloud_speed = 0
func _process(delta):
	for cloud in $back_objects/clouds.get_children():
		if cloud.position.x > 1700:
			cloud.position.x = randi_range(-2400,0)
			cloud.position.y = randi_range(50,1000)
			cloud.frame = randi_range(0,54)
		cloud.position.x += cloud_speed * delta
	#if once:
		#old_level = Global.level
		#once = false
		#Global.player_death = false
	if Input.is_action_just_pressed("retry") or Global.level != old_level or Global.filled <= -1000:
		if  Global.level != old_level:
			Global.player_death = false
		else:
			Global.player_death = true
		retry_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_packed(start_screen)
	if Global.level == 20:
		if Global.natural_level_progession == 0:
			Global.music_player1.stop()
			if not Global.wind.is_playing():
				Global.wind.play()
		elif Global.natural_level_progession >= 0.4:
			
			if not Global.boss1.is_playing():
				Global.boss1.play()
		
		if Global.natural_level_progession == 0.1:
			Global.wind.stop()
			Global.natural_level_progession = 0.2
			retry_scene()
	else:
		
		if not Global.music_player1.is_playing():
			await get_tree().create_timer(1).timeout
			Global.music_player1.play()
		if not Global.wind.is_playing():
			Global.wind.play()
		
func retry_scene():
	# Get the current scene
	if is_inside_tree() and get_tree():
		
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
