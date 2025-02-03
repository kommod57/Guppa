extends StaticBody2D

var extras = []
"""Dangerous u set rot value to -1"""

# Called when the node enters the scene tree for the first time.
func _ready():
	once = true
	if Global.level == 19:
		$CollisionShape2D/drip.wait_time = 0.1
		$CollisionShape2D.position = Vector2(640,1120)
		$CollisionShape2D.rotation_degrees = -180
		extras = await _build_up(7,0,40,-180)
		$CollisionShape2D.position = Vector2(1400,340)
		$CollisionShape2D.rotation_degrees = -1
		var more = await _build_up(3,0,60,-1)
		for m in more:
			extras.append(m)
		$CollisionShape2D.position = Vector2(500,300)
		$CollisionShape2D.rotation_degrees = -1
		var nore = await _build_up(1,0,600,-1)
		for n in nore:
			extras.append(n)
	elif Global.level == 20 and (Global.natural_level_progession >= 0.2):
		$CollisionShape2D.position = Vector2(600,650)
		$CollisionShape2D.rotation_degrees = -1
	
	else:
		queue_free()

var once = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.natural_level_progession == 0.4 and Global.level == 20:
		
		if once:
			Global.filled = 0
			$CollisionShape2D/drip.wait_time = 0.1
			$CollisionShape2D.position = Vector2(0,-50)
			$CollisionShape2D.rotation_degrees = -1
			extras = await _build_up(7,0,200,-1)
			$CollisionShape2D.position = Vector2(600,650)
			$CollisionShape2D.rotation_degrees = -1
			once = false
			
		

var rng = RandomNumberGenerator.new()
var ex_scene = load('res://excretion.tscn')
func _on_drip_timeout():
	if $CollisionShape2D.rotation_degrees == -1 or $CollisionShape2D.rotation_degrees == -180:
		$CollisionShape2D/AnimatedSprite2D.animation = 'green'
	else:
		$CollisionShape2D/AnimatedSprite2D.animation = 'red'
	if not Global.lever_on:
		var ex = ex_scene.instantiate()
		if $CollisionShape2D.rotation_degrees == -1 or $CollisionShape2D.rotation_degrees == -180:
			ex.rotation_degrees = -1
		else:
			ex.rotation_degrees = 1
		var move_x = rng.randi_range(-10,10)
		ex.position = $CollisionShape2D/ex_pos.position
		ex.position.x += move_x
		if ex:
			$CollisionShape2D/exs.add_child(ex)
	for foun in extras:
		if foun.rotation_degrees == -1 or foun.rotation_degrees == -180:
			foun.get_children()[0].animation = 'green'
		else:
			foun.get_children()[0].animation = 'red'
		if not Global.lever_on:
			var ax = ex_scene.instantiate()
			if foun.rotation_degrees == -1 or foun.rotation_degrees == -180:
				ax.rotation_degrees = -1
				if foun.rotation_degrees == -180:
					ax.rotation_degrees = -180
			else:
				ax.rotation_degrees = 1
			var move_x = rng.randi_range(-10,10)
			ax.position = foun.get_children()[1].position

			ax.position.x += move_x
			if ax:
				foun.get_children()[3].add_child(ax)

func _build_up(num, start = 0, x_diff = 100, Rotation = 0):
	var exs = $CollisionShape2D.get_node_or_null("exs")  # Safely get the node
	if exs:  # Ensure it exists before accessing children
		for child in exs.get_children():
			if is_instance_valid(child):
				child.queue_free()
	
		await get_tree().process_frame  # Allow deletion to process
	var og_x = x_diff
	var og_start = start
	var verys = []
	for i in range(0,num):
		var new = ''
		new = $CollisionShape2D.duplicate()
		
		new.position.y += start
		new.position.x += x_diff
		new.rotation_degrees = Rotation
		self.add_child(new)
		start += og_start
		x_diff += og_x
		verys.append(new)
	return verys
