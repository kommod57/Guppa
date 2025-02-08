extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.level == 4:
		position += Vector2(-620,-200)
		_build_up(1,150,0)
		_build_up(1,-75,0)
	elif Global.level == 7 or Global.level == 8:
		position.y -= 50
	elif Global.level == 9 or Global.level== 10:
		position += Vector2(-380,0)
		rotation_degrees = 180
		_build_up(6,40,0, 0)
		_build_up(1,270,0, 180)
		_build_up(6,40,-80, 0)
		_build_up(6,40,80, 0)
	elif Global.level == 12:
		position = Vector2(850,700)
	elif Global.level == 17:
		position = Vector2(300,650)
		_build_up(2,-100,40, 0)
	elif Global.level == 19:
		position = Vector2(200,500)
		_build_up(4,-80,0, 0)
	elif Global.level == 20 and Global.natural_level_progession == 0:
		position = Vector2(200,900)
		_build_up(6,-160,0, 0)
	elif Global.level == 20 and (Global.natural_level_progession >= 0.2):
		position = Vector2(-40,800)
		_build_up(17,0,70, 0, Vector2(20,0))
		_build_up(18,70,0, 90,Vector2(40,-840))
		_build_up(18,70,0, -90,Vector2(1640,-840))
		_build_up(24,0,70, 0, Vector2(20,340))
		_build_up(24,0,70, 180, Vector2(20,370))
		_build_up(1,0,0, 0, Vector2(1200,170))


	else:
		queue_free()
	if Global.level == 8:
		position.x += 20
		_build_up(5,-80,40)

func _build_up(num, start = -80, x_diff = 0, Rotation = 0, move_over = Vector2(0,0)):
	var og_x = x_diff
	var og_start = start
	for i in range(0,num):
		var new = $one_way.duplicate()
		new.position.y += start + move_over[1]
		new.position.x += x_diff + move_over[0]
		new.rotation_degrees = Rotation
		self.add_child(new)
		
		start += og_start
		x_diff += og_x
		
	

var once = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#if Global.level == 9:
		#if Global.lever_on and once:
			#var old_pos = position
			#rotation_degrees += 180
			#position = old_pos
			#once = false
		#elif not Global.lever_on:
			#once = true
