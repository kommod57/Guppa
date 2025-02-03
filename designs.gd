extends Node2D

var first_time = 0
func _ready():
	$word_back.hide()
	first_time = 0
	if Global.level == 1:
		$level_1/Object3.hide()
		$level_1/Object3/CollisionShape2D.disabled = true
		$level_1/Object3/CollisionShape2D2.disabled = true
	elif Global.level == 2:
		$level_1/Object3.hide()
		$level_1/Object3/CollisionShape2D.disabled = true
		$level_1/Object3/CollisionShape2D2.disabled = true
	elif Global.level == 3 or Global.level == 0:
		$level_1/Object3.show()
		$level_1/Object3/CollisionShape2D.disabled = false
		$level_1/Object3/CollisionShape2D2.disabled = false
		
		$level_1/Object1.hide()
		$level_1/Object2.hide()
		$level_1/Object2/stair.disabled = true
		$level_1/Object2/stair2.disabled = true
		$level_1/Object2/stair3.disabled = true
		$level_1/Object2/stair4.disabled = true
		$level_1/Object2/CollisionShape2D4.disabled = true
		$level_1/Object2/CollisionShape2D5.disabled = true
		$level_1/Object2/CollisionShape2D6.disabled = true
		$level_1/Object1/CollisionShape2D3.disabled = true
		$level_1/Object1/CollisionShape2D4.disabled = true
		$level_1/Object1/CollisionShape2D5.disabled = true
	elif Global.level > 3:
		$level_1/Object1.show()
		$level_1/Object2.show()
		$level_1/Object3.show()
		$level_1/Object3/CollisionShape2D.position.y = -2000
		$level_1/Object3/CollisionShape2D2.position.y = -2000
		$level_1/Object2/stair.position.y = -2000
		$level_1/Object2/stair2.position.y = -2000
		$level_1/Object2/stair3.position.y = -2000
		$level_1/Object2/stair4.position.y = -2000
		$level_1/Object2/CollisionShape2D4.position.y = -2000
		$level_1/Object2/CollisionShape2D5.position.y = -2000
		$level_1/Object2/CollisionShape2D6.position.y = -2000
		$level_1/Object1/CollisionShape2D3.position.y = -2000
		$level_1/Object1/CollisionShape2D4.position.y = -2000
		$level_1/Object1/CollisionShape2D5.position.y = -2000
	if Global.level == 4:
		$level_1/Object3/CollisionShape2D.position.y = 0
		$level_1/Object3/CollisionShape2D.position.x += 5
		$level_1/Object1/CollisionShape2D3.position.y = -480
		$level_1/Object1/CollisionShape2D3.position.x -= 300
		$level_1/Object1/CollisionShape2D5.position.y = -300
		$level_1/Object1/CollisionShape2D5.position.x -= 600
	elif Global.level == 5:
		$level_1/Object3/CollisionShape2D.position.y = 500
		$level_1/Object3/CollisionShape2D.position.x += 600
	elif Global.level == 6:
		$level_1/Object1/CollisionShape2D5.position += Vector2(50,2000-200)
		$level_1/Object2/CollisionShape2D5.position += Vector2(-180,2000-250)
	elif Global.level == 7:
		$level_1/Object2/CollisionShape2D5.position += Vector2(-100,2000-250)
	elif Global.level == 8:
		$level_1/Object2/CollisionShape2D5.position += Vector2(420,2000-600)
	
	
var to_del = []	
func _process(_delta):
	if not Global.lever_on:
		$level_1/Object2/switch_block.disabled = false
		$level_1/Object2/switch_block/ColorRect2.modulate.a = 1
		
		if Global.level == 2:

			$level_1/Object2/switch_block.position = Vector2(-397.143,-29)
		elif Global.level == 6:

			$level_1/Object2/switch_block.position = Vector2(-250,-200)
		elif Global.level == 8:
			$level_1/Object2/switch_block.position = Vector2(0,-2000)

		else:

			$level_1/Object2/switch_block.position = Vector2(0,-2000)
	else:
		$level_1/Object2/switch_block.disabled = true 
		$level_1/Object2/switch_block/ColorRect2.modulate.a = 0.5

	if Global.level == 0:
		if first_time == 0 and not Global.push:
			first_time = 1
			to_del = await _make_words('Arrowkeys/WASD', 0.5)
			first_time = 2
		if first_time == 3 and not Global.push:
			first_time = 4
			await _delete_words(to_del)
			to_del = await _make_words('Esc/q to exit level', 0.5)
		
		if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed('left') or Input.is_action_just_pressed('right'):
			await _delete_words(to_del)
			if first_time == 2:
				first_time = 3
			
		
	if Global.level == 1:
		if first_time == 0 and not Global.push:
			first_time = 1
			to_del = await _make_words('1: Guppa head', 0.5)
			
		$level_1/Object1.show()
		$level_1/Object2.hide()
		$level_1/Object2/stair.disabled = true
		$level_1/Object2/stair2.disabled = true
		$level_1/Object2/stair3.disabled = true
		$level_1/Object2/stair4.disabled = true
		$level_1/Object2/CollisionShape2D4.disabled = true
		$level_1/Object2/CollisionShape2D5.disabled = true
		$level_1/Object2/CollisionShape2D6.disabled = true
		if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed('special'):
			_delete_words(to_del)
		if Global.push and first_time == 1:
			_delete_words(to_del)
			first_time = 2
			to_del = await _make_words('Space to twirl', 0.5)
			
	elif Global.level == 2:
		$level_1/Object2.show()
		if first_time == 0:
			
			first_time = 1
			to_del = await _make_words('2: Space to flip switches', 0.5)
		if Input.is_action_just_pressed('special') and first_time == 1:
			first_time = 2
			_delete_words(to_del)
		$level_1/Object1.hide()
		$level_1/Object2/stair.disabled = false
		$level_1/Object2/stair2.disabled = false
		$level_1/Object2/stair3.disabled = false
		$level_1/Object2/stair4.disabled = false
		$level_1/Object2/CollisionShape2D4.disabled = false
		$level_1/Object2/CollisionShape2D5.disabled = false
		$level_1/Object2/CollisionShape2D6.disabled = false
		$level_1/Object2.show()
		$level_1/Object1/CollisionShape2D3.disabled = true
		$level_1/Object1/CollisionShape2D4.disabled = true
		$level_1/Object1/CollisionShape2D5.disabled = true

	elif Global.level == 3:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words('3: Dont touch that green stuff\\Seriously', 0.5)
			first_time = 2
		if first_time == 2:
			await get_tree().create_timer(2).timeout
			first_time = 3
			_delete_words(to_del)
			to_del = await _make_words('Space to throw flower at the bucket', 0.5)
		if first_time == 3:
			first_time = 4
		if first_time == 4:
			_delete_words(to_del)
	elif Global.level == 4:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words('4: Flower under the floor', 0.5)
			first_time = 2
		if first_time == 2:
			await get_tree().create_timer(2).timeout
			first_time = 3
			_delete_words(to_del)
	elif Global.level == 5:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words('5: Hold down/s to pull', 0.5)
			first_time = 2
		if first_time == 2:
			if Input.is_action_just_pressed("down"):
				_delete_words(to_del)
	elif Global.level == 6:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words('6: R to restart', 0.5)
			first_time = 2
		if first_time == 2:
			await get_tree().create_timer(2).timeout
			first_time = 3
			_delete_words(to_del)
	elif Global.level == 7:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words('7: Through the virus fall', 0.5)
			first_time = 2
		if first_time == 2:
			await get_tree().create_timer(2).timeout
			first_time = 3
			_delete_words(to_del)
	elif Global.level == 8:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words('8: The spin of death', 0.5)
			first_time = 2
		if first_time == 2:
			await get_tree().create_timer(2).timeout
			first_time = 3
			_delete_words(to_del)
	elif Global.level == 9:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words('9: Up', 0.5)
			first_time = 2
		if first_time == 2:
			await get_tree().create_timer(2).timeout
			first_time = 3
			_delete_words(to_del)
	elif Global.level == 10:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words('10: No switch this time', 0.5)
			first_time = 2
		if first_time == 2:
			await get_tree().create_timer(2).timeout
			first_time = 3
			_delete_words(to_del)
	elif Global.level == 11:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("11: Flower?", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
			first_time = 3
	elif Global.level == 12:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("12: Conveyor", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
			first_time = 3
	elif Global.level == 13:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("13: dont touch those guys\\they are too far gone", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
			first_time = 3
	elif Global.level == 14:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("14: Verticle", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
			first_time = 3
	elif Global.level == 15:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("15: Be quick", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
			first_time = 3
	elif Global.level == 16:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("16: Fountains", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
			first_time = 3
		elif first_time == 3:
			await get_tree().create_timer(2).timeout
			first_time = 4
			to_del = await _make_words("You can press down\\To pull levers", 0.5)
		elif first_time == 4:
			await _delete_words(to_del)
	elif Global.level == 17:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("17: Dont try it", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
	elif Global.level == 18:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("18: \"wall jumping\"", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
	elif Global.level == 19:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("19: Do you have\\What it takes", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
	
			
	elif Global.level == 20 and Global.natural_level_progession == 0:
		await get_tree().create_timer(5).timeout
		if first_time == 0:
			first_time = 1
			to_del = await _make_words('Guppa: Where is', 0.5)
			await get_tree().create_timer(1).timeout
			await _delete_words(to_del)
			await get_tree().create_timer(1).timeout
			first_time = 2
			to_del = await _make_words('The BUCKET!?', 0.5,true,Vector2(500,300),0.2)
			first_time = 3
		if first_time == 3:
			await get_tree().create_timer(2).timeout
			first_time = 4
			_delete_words(to_del)
	elif Global.level == 20 and Global.natural_level_progession == 0.3:
		$word_back.show()
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("TAKE COVER", 0.5)
			await get_tree().create_timer(4).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
			Global.natural_level_progession = 0.4
			$word_back.hide()
	elif Global.level == 21:
		if first_time == 0:
			first_time = 1
			to_del = await _make_words("21: Welcome to the Savannah", 0.5)
			await get_tree().create_timer(2).timeout
			first_time = 2
		elif first_time == 2:
			await _delete_words(to_del)
			first_time = 3

			
	
			
		
		
@export var chars_dic = { "A": 0, "a": 1, "B": 2, "b": 3, "C": 4, "c": 5,
"D": 6, "d": 7, "E": 8, "e": 9, "F": 10, "f": 11, "G": 12, "g": 13, "H": 14,
"h": 15, "I": 16, "i": 17, "J": 18, "j": 19, "K": 20, "k": 21, "L": 22, "l": 23,
"M": 24, "m": 25, "N": 26,"n": 27, "O": 28, "o": 29, "P": 30, "p": 31, "Q": 32,
"q": 33, "R": 34, "r": 35, "S": 36, "s": 37, "T": 38, "t": 39, "U": 40, "u": 41,
"V": 42, "v": 43, "W": 44, "w": 45, "X": 46, "x": 47, "Y": 48, "y": 49, "Z": 50,
"z": 51, "!": 52, "\"": 53, "#": 55, "$": 56, "%": 57, "&": 58, "^": 59, "(": 60,
")": 61, "+": 62, ",": 63, ".": 64, "/": 65, "0": 66, "1": 67, "2": 68, "3": 69,
"4": 70, "5": 71, "6": 72, "7": 73, "8": 74, "9": 75, ":": 76, ";": 77, "<": 78,
"=": 79, ">": 80, "?": 81, "@": 82}	

func _make_words(text,size=1.0,dialogue=true, pos = Vector2(500,300), timeout=0.05):
	var x = 0
	var y = 0
	var what_to_delete = []
	var let = $CanvasLayer/letters
	for Char in text:
		if Char in chars_dic:
			let.scale = Vector2(size,size)
			let.frame = chars_dic[Char]
			x += 50 * size
		elif  Char == "\\":
			let.frame = 83
			y += 100 * size
			x = 0
		else:
			let.frame = 83
			x += 50 * size
		let.position = Vector2(pos.x + x, pos.y + y)
		var new = let.duplicate()
		new.name = Char
		new.show()
		add_child(new)
		what_to_delete.append(new)
		if dialogue:
			await get_tree().create_timer(timeout).timeout
	return what_to_delete
		
func _delete_words(chars_list):
	for Char in chars_list:
		if Char != null:
			if Char.is_inside_tree():
				Char.queue_free()
				await get_tree().create_timer(.05).timeout
