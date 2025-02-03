extends Node2D

var rng = RandomNumberGenerator.new()
var falling_y = rng.randi_range(30,300)
var move_x = rng.randi_range(-50,50)
var spin = rng.randi_range(-300,300)
var start_x = rng.randi_range(0,1600)
var blink = rng.randi_range(0,10)

func _ready():
	var guppa = $VBoxContainer
	guppa.show()
	falling_y = rng.randi_range(30,300)
	move_x = rng.randi_range(-50,50)

	start_x = rng.randi_range(0,1600)
	blink = rng.randi_range(0,10)
	guppa.position = Vector2(start_x,0)
	guppa.rotation_degrees = move_x * -1
	$VBoxContainer/AnimatedSprite2D.animation = 'move'
	$VBoxContainer/AnimatedSprite2D.play()
func _process(delta):
	var guppa = $VBoxContainer
	if not on_mouse:
		guppa.position += Vector2(move_x,falling_y) * delta
	
	blink = rng.randi_range(0,300)
	if blink == 0:
		$VBoxContainer/AnimatedSprite2D.animation = 'blink'
	if not $VBoxContainer/AnimatedSprite2D.is_playing():
		$VBoxContainer/AnimatedSprite2D.play()
		$VBoxContainer/AnimatedSprite2D.animation = 'move'
	if not on_mouse and (guppa.position.y > 1220 or guppa.position.x > 1620 or guppa.position.x < -20):
		start_x = rng.randi_range(0,1600)
		falling_y = rng.randi_range(30,300)
		move_x = rng.randi_range(-50,50)
		spin = rng.randi_range(-300,300)
		guppa.position = Vector2(start_x,-10)
		guppa.rotation_degrees = move_x * -1


func _on_v_box_container_mouse_entered():
	$VBoxContainer/AnimatedSprite2D.animation = 'blink'
var on_mouse = false

func _on_v_box_container_gui_input(event):
	if Input.is_action_pressed("click"):
		$VBoxContainer.position += event.position
		on_mouse = true
	else:
		on_mouse = false
