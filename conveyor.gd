extends StaticBody2D
var starting_ani = ''
var conveyors = []
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$conver_col/AnimatedSprite2D.play()
	if Global.level == 12:
		starting_ani = 'move_left'
		$conver_col.position = Vector2(500,1050)
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		conveyors = _build_up(5)
	elif Global.level == 13:
		starting_ani = 'move_left'
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		$conver_col.position = Vector2(623,500)
		conveyors = _build_up(2)
	elif Global.level == 14:
		starting_ani = 'move_left'
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		$conver_col.position = Vector2(500,950)
		$conver_col.rotation_degrees = 90
		conveyors = _build_up(3, -100, 0, 90)
	elif Global.level == 15:
		#starting_ani = 'move_right'
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		$conver_col.position = Vector2(850,850)
		var conveyorss = _build_up(1,0,0,0)
		conveyors = _build_up(3,0,100,0)
		for c in conveyorss:
			conveyors.append(c)
		$conver_col/AnimatedSprite2D.animation = 'move_right'
		$conver_col.position = Vector2(300,350)
		var conveyorsss = _build_up(5,0,100,180)
		for c in conveyorsss:
			conveyors.append(c)
		$conver_col.position = Vector2(500,920)
		$conver_col.rotation_degrees = -90
	elif Global.level == 17:
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		$conver_col.position = Vector2(500,900)
	elif Global.level == 18:
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		$conver_col.position = Vector2(500,1100)
		$conver_col.rotation_degrees = 90
		conveyors = _build_up(1,0,0,90)
		var conveyorss = _build_up(3,-150,-80,90)
		for c in conveyorss:
			conveyors.append(c)
		$conver_col/AnimatedSprite2D.animation = 'move_right'
		$conver_col.position = Vector2(800,900)
		$conver_col.rotation_degrees = -90
		var conveyorz = _build_up(3,-250,100,-90)
		for c in conveyorz:
			conveyors.append(c)
		$conver_col.position = Vector2(1000,800)
		$conver_col.rotation_degrees = -90
	elif Global.level == 19:
		$conver_col/AnimatedSprite2D.animation = 'move_right'
		$conver_col.position = Vector2(-100,1100)
		$conver_col.rotation_degrees = 180
		conveyors = _build_up(7,0,100,180)
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		$conver_col.position = Vector2(1600,1100)
		$conver_col.rotation_degrees = 0
		var conveyorz = _build_up(6,0,-100,0)
		for c in conveyorz:
			conveyors.append(c)
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		$conver_col.position = Vector2(700,630)
		var conveyorrz = _build_up(2,100,0,90)
		for c in conveyorrz:
			conveyors.append(c)
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		$conver_col.position = Vector2(800,550)
		var conveyorrrz = _build_up(6,-100,0,90)
		for c in conveyorrrz:
			conveyors.append(c)
		$conver_col/AnimatedSprite2D.animation = 'move_left'
		$conver_col.position = Vector2(1600,1100)
		$conver_col.rotation_degrees = 0
		
	else:
		
		queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if abs($conver_col.rotation_degrees) == 90:
		#pass
	#elif $conver_col/AnimatedSprite2D.animation == 'move_right':
		#$conver_col.rotation_degrees = 180
	#elif $conver_col/AnimatedSprite2D.animation == 'still':
		#$conver_col/AnimatedSprite2D.rotation_degrees = 1
	#else:
		#$conver_col.rotation_degrees = 0
	for sprite in conveyors:
		sprite.get_children()[0].play()
		#if sprite.rotation_degrees == 90:
			#pass
		#elif sprite.get_children()[0].animation == 'move_right':
			#sprite.rotation_degrees = 180
		#elif sprite.get_children()[0].animation == 'still':
			#sprite.rotation_degrees = 1
		#else:
			#sprite.rotation_degrees = 0
	#if Global.level == 13:
		#if Global.lever_on:
			#if starting_ani == 'move_left':
				#$conver_col/AnimatedSprite2D.animation = 'move_right'
				#for sprite in conveyors:
					#sprite.get_children()[0].animation = 'move_right'
			#else:
				#$conver_col/AnimatedSprite2D.animation = 'move_left'
				#for sprite in conveyors:
					#sprite.get_children()[0].animation = 'move_left'
		#else:
			#$conver_col/AnimatedSprite2D.animation = starting_ani
			#for sprite in conveyors:
				#sprite.get_children()[0].animation = starting_ani
			#
		#
	#
func _build_up(num, start = 0, x_diff = 100, Rotation = 0):
	var og_x = x_diff
	var og_start = start
	var verys = []
	for i in range(0,num):
		var new = ''
		new = $conver_col.duplicate()
		new.position.y += start
		new.position.x += x_diff
		new.rotation_degrees = Rotation
		self.add_child(new)
		start += og_start
		x_diff += og_x
		verys.append(new)
		
	return verys
