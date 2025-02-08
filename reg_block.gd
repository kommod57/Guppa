extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.level == 0 or Global.level == 3:
		$switch_col3.position = Vector2(800,880)
		_build_up(1,0,80)
	elif Global.level == 1:
		$switch_col3.position = Vector2(660,720)
		_build_up(14,0,40)
		$switch_col3.position = Vector2(1400,880)
		_build_up(1,80,-120)
	elif Global.level == 2:
		$switch_col3.position = Vector2(1200,1060)
		_build_up(10,0,40)
		$switch_col3.position = Vector2(1080,1060)
		_build_up(2,40,0)
	elif Global.level == 4:
		$switch_col3.position = Vector2(720,650)
		_build_up(2,0,40)
		$switch_col3.position = Vector2(850,420)
		_build_up(1,0,-40)
	elif Global.level == 5:
		$switch_col3.position = Vector2(1400,900)
		_build_up(2,0,-40)
	elif Global.level == 6:
		$switch_col3.position = Vector2(730,920)
		_build_up(14,0,40)
		$switch_col3.position = Vector2(730,860)
	elif Global.level == 7:
		$switch_col3.position = Vector2(800,700)
		_build_up(1,0,40)
	elif Global.level == 8:
		$switch_col3.position = Vector2(1500,420)
		_build_up(1,50,50)
	elif Global.level == 9 or Global.level == 10:
		$switch_col3.position = Vector2(725,540)
		_build_up(1)
		$switch_col3.position = Vector2(1200,1120)
		#$switch_col3.position = Vector2(900,1120)
	elif Global.level == 11:
		$switch_col3.position = Vector2(1400,200)
		_build_up(5,0,40)
		#$switch_col3.position = Vector2(1400,160)
		
	elif Global.level == 12:
		$switch_col3.position = Vector2(1160,600)
	elif Global.level == 13:
		$switch_col3.position = Vector2(723,200)
	elif Global.level == 14:
		$switch_col3.position = Vector2(723,600)
		#_build_up(1)
		#$switch_col3.position = Vector2(550,480)
	elif Global.level == 15:
		$switch_col3.position = Vector2(800,800)
		_build_up(8,40,0)
		$switch_col3.position = Vector2(1400,1000)
		
	elif Global.level == 17:
		$switch_col3.position = Vector2(1300,1120)
		_build_up(1)
		$switch_col3.position = Vector2(300,800)
	elif Global.level == 18:
		$switch_col3.position = Vector2(30,600)
		_build_up(3,0,40)
		_build_up(1,-40,160)
		_build_up(1,0,0)
		$switch_col3.position = Vector2(1500,200)
		_build_up(5,0,-40)
	elif Global.level == 19:
		$switch_col3.position = Vector2(1420,300)
		_build_up(5,-40,0)
		_build_up(5,0,40)
		$switch_col3.position = Vector2(1300,200)
		_build_up(1,0,0)
		$switch_col3.position = Vector2(1420,300)
	#elif  Global.level == 20 and Global.natural_level_progession == 0.2:
		#$switch_col3.position = Vector2(580,800)
		#_build_up(16,0,40)
	else:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _build_up(num, start = 0, x_diff = 0, Rotation = 0):
	var og_x = x_diff
	var og_start = start
	var shapes = []
	for i in range(0,num):
		var new = ''
		new = $switch_col3.duplicate()
		new.position.y += start
		new.position.x += x_diff
		new.rotation_degrees = Rotation
		self.add_child(new)
		start += og_start
		x_diff += og_x
		shapes.append(new)
	return shapes
