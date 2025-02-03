extends Control
@export var start: PackedScene = load("res://level_1.tscn")
var guppa_scene = load("res://begining_guppa.tscn")

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

signal level_clicked()

@onready var begin = $letterbox
var begins = []
var rng = RandomNumberGenerator.new()

func _ready():
	if Global.level > Global.nat_level:
		Global.nat_level = Global.level
	await _make_guppas()
	Global.boss1.stop()
	Global.music_player1.stop()

	var levels = ""
	for i in range(0,Global.nat_level + 1):
		if i < 10 and i > 0:
			levels += str(i)
		elif i == 10:
			levels += 'a' + str(i)
		elif i == 11:
			levels += '\\' + 'a' + str(i)
		elif i > 11 and i <= 20:
			levels += 'a' + str(i)
		elif i == 21:
			levels += '\\' + 'a' + str(i)
		elif i > 21 and i <= 30:
			levels += 'a' + str(i)

	if Global.nat_level != 0:
		_make_words(levels, 0.5, false, Vector2(350,500),100,true)
	await _make_words("Guppas",1.0,true)
	_make_words("\\\\    press(SPACE)",.3,false)
	#begin.connect("gui_input", Callable(self, "_on_level_clicked"))
	for beg in begins:
		beg.connect("gui_input", Callable(self, "_on_level_clicked").bind(beg))

func _make_guppas():
	for i in range(0, Global.nat_level):
		var new = guppa_scene.instantiate()
		$guppas.add_child(new)

func _process(_delta):
	if not Global.music_player2.is_playing():
		Global.music_player2.play()
	if Input.is_action_just_pressed("special"):
		Global.level = Global.nat_level
		Global.music_player2.stop()
		get_tree().change_scene_to_packed(start)
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
		
	
var last_char = ''
func _make_words(text,Size=1.0,dialogue=true, Position = Vector2(600,300), extra_spacing=0,special=false):
	var x = 0
	var y = 0

	
	for Char in text:
		
		if Char in chars_dic:
			$letterbox/letters.scale = Vector2(Size,Size)
			$letterbox/letters.frame = chars_dic[Char]
			x += (50 + extra_spacing) * Size
		elif  Char == "\\":
			$letterbox/letters.frame = 83
			y += 100 * Size
			x = 0
		else:
			$letterbox/letters.frame = 83
			x += 50 * Size
		$letterbox.position = Vector2(Position.x + x, Position.y + y)
		var new = $letterbox.duplicate()
		begins.append(new)
		if not special or (special and Char != 'a'):
			
			add_child(new)
		if dialogue:
			await get_tree().create_timer(.05).timeout
		
		if special:
			if last_char == 'a':
				extra_spacing = 0
			elif Char == 'a':
				extra_spacing = -100
				
			else:
				extra_spacing = 100
			
			last_char = Char
		
		
	

var change_level = false
func _on_level_clicked(event, arg):
	var sprite = arg.get_children()
	var target = sprite[0].frame
	var my_key = ''
	change_level = false
	if target >= 66 and target <= 75:
		change_level = true
		for key in chars_dic.keys():
			if chars_dic[key] == target:
				my_key = int(key)

	if event is InputEventMouseButton:
		var dontstart = false
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if change_level:
				if arg.global_position.y == 500:
					if arg.global_position.x != 1075 and arg.global_position.x != 1100:
						Global.level = my_key
					else:
						Global.level = 10
				elif arg.global_position.y == 550:
					if my_key == 1:
						if arg.global_position.x != 400 and arg.global_position.x != 425:
							dontstart = true
					if arg.global_position.x != 1075 and arg.global_position.x != 1100:
						Global.level = my_key + 10
					else:
						Global.level = 20
						
				elif arg.global_position.y == 600:
					if my_key == 2:
						if arg.global_position.x != 500 and arg.global_position.x != 525:
							dontstart = true
					if arg.global_position.x != 1075 and arg.global_position.x != 1100:
						Global.level = my_key + 20
					else:
						Global.level = 30
			else:
				Global.level = Global.nat_level
			if not dontstart:
				get_tree().change_scene_to_packed(start)
