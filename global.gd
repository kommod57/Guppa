extends Node

var player_pos = Vector2(0,0)
var scared_guppa_pos = Vector2(0,0)
var player_dir = 0
var player_speed

var head = false

var push = false

var filled = 0
var sprite_evil_fill = 0

#ui
var level = 0
var nat_level = 0
var lever_on = false
var dangerous_particles = false
var empty_bucket = false
var natural_level_progession = 0.4

#npc stuff
var jumpy = false

#level interface
# Declare the music player as a child node
var music_player1: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var music_player2: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var boss1: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var boss2: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var stream1 = load("res://Still_Bittersweet.mp3")
var stream2 = load("res://Long_Ago....mp3")
var stream4 = load("res://Black_Bean.mp3")
var stream3 = load("res://boss1.mp3")
func _ready():
	add_child(music_player1)
	music_player1.stream = stream1
	#music_player.loop = true
	music_player1.play()
	add_child(music_player2)
	music_player2.stream = stream2
	add_child(boss1)
	boss1.stream = stream3
	add_child(boss2)
	boss2.stream = stream4
	

