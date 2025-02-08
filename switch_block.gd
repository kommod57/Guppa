extends StaticBody2D

var on_shapes = []
var off_shapes = []
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Global.level == 2:
		$switch_col.position = Vector2(1080,1060)
		on_shapes = _build_up(true, 3, 0,40,0)
	elif Global.level == 6:
		$switch_col.position = Vector2(1330,860)
	elif Global.level == 8:
		$switch_col.position = Vector2(1500,420)
		on_shapes = _build_up(true, 6, -40,0,0)
	elif Global.level == 9 or Global.level == 10:
		$switch_col.position = Vector2(725,140)
		$switch_col2.position = Vector2(725,140)
		#if Global.level == 9:
		on_shapes = _build_up(true, 2, 260,0,0)
		off_shapes = _build_up(false, 1,440,0,0)
		$switch_col2.position = Vector2(725,580)
		var off_shapes1 = _build_up(false, 5,0,40,0)
		var off_shapes2 = _build_up(false, 5,0,-40,0)
		for shape in off_shapes1:
			off_shapes.append(shape)
		for shape in off_shapes2:
			off_shapes.append(shape)
		$switch_col.position = Vector2(1450,1000)
		var on_shapes1 =  _build_up(true, 3,-100,-100)
		for shape in on_shapes1:
			on_shapes.append(shape)
		#$switch_col2.position = Vector2(1000,1120)
		#$switch_col.position = Vector2(1200,1120)
	elif Global.level == 11:
		$switch_col.position = Vector2(1150,1270)
		$switch_col2.position = Vector2(1150,1150)
		on_shapes = _build_up(true,20,-200)
		off_shapes = _build_up(false,10,-200)
		$switch_col2.position = Vector2(1440,190)
		$switch_col.position = Vector2(1400,190)
	elif Global.level == 13:
		$switch_col.position = Vector2(550,480)
		$switch_col2.position = Vector2(900,480)
	elif Global.level == 18:
		$switch_col2.position = Vector2(750,900)
	
	else:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Global.lever_on:
		$switch_col.disabled = false
		$switch_col/ColorRect2.modulate.a = 1
		$switch_col2.disabled = true
		$switch_col2/ColorRect2.modulate.a = 0.5
		for shape in on_shapes:
			shape.disabled = false
			for child in shape.get_children():
				child.modulate.a = 1
		for shape in off_shapes:
			shape.disabled = true
			for child in shape.get_children():
				child.modulate.a = 0.5
	else:
		$switch_col.disabled = true 
		$switch_col/ColorRect2.modulate.a = 0.5
		$switch_col2.disabled = false
		$switch_col2/ColorRect2.modulate.a = 1
		for shape in on_shapes:
			shape.disabled = true
			for child in shape.get_children():
				child.modulate.a = 0.5
		for shape in off_shapes:
			shape.disabled = false
			for child in shape.get_children():
				child.modulate.a = 1
	
		
func _build_up(on, num, start = -80, x_diff = 0, Rotation = 0):
	var og_x = x_diff
	var og_start = start
	var shapes = []
	for i in range(0,num):
		var new = ''
		if on:
			new = $switch_col.duplicate()
		else:
			new = $switch_col2.duplicate()
		new.position.y += start
		new.position.x += x_diff
		new.rotation_degrees = Rotation
		self.add_child(new)
		start += og_start
		x_diff += og_x
		shapes.append(new)
	return shapes



