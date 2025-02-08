extends StaticBody2D

var extras = []
"""Dangerous u set rot value to -1"""

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D/AnimatedSprite2D.animation = 'red'
	if Global.level == 16:
		$CollisionShape2D.position = Vector2(500,500)
		extras = _build_up(1,0,100,-1)
	elif Global.level == 17:
		$CollisionShape2D/drip.wait_time = 0.1
		$CollisionShape2D.rotation_degrees = -1
		$CollisionShape2D.position = Vector2(500,100)
		extras = _build_up(7,0,50,-1)
	elif Global.level == 18:
		$CollisionShape2D.rotation_degrees = -1
		$CollisionShape2D.position = Vector2(800,1120)
		$CollisionShape2D.rotation_degrees = -180
		extras = _build_up(11,0,50,-180)
		
	elif Global.level == 19:
		$CollisionShape2D.position = Vector2(1500,100)
	else:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

var rng = RandomNumberGenerator.new()
var ex_scene = load('res://excretion.tscn')
func _on_drip_timeout():
	if $CollisionShape2D.rotation_degrees == -1 or $CollisionShape2D.rotation_degrees == -180:
		$CollisionShape2D/AnimatedSprite2D.animation = 'green'
	else:
		$CollisionShape2D/AnimatedSprite2D.animation = 'red'
	if Global.lever_on:
		var ex = ex_scene.instantiate()
		if $CollisionShape2D.rotation_degrees == -1 or $CollisionShape2D.rotation_degrees == -180:
			ex.rotation_degrees = -1
		else:
			ex.rotation_degrees = 1
		var move_x = rng.randi_range(-10,10)
		ex.position = $CollisionShape2D/ex_pos.position
		ex.position.x += move_x
		$CollisionShape2D/exs.add_child(ex)
	for foun in extras:
		if foun.rotation_degrees == -1 or foun.rotation_degrees == -180:
			foun.get_children()[0].animation = 'green'
		else:
			foun.get_children()[0].animation = 'red'
		if Global.lever_on:
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
			foun.get_children()[3].add_child(ax)

func _build_up(num, start = 0, x_diff = 100, Rotation = 0):
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
