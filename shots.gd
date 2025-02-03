extends Area2D

var current_pos = global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	current_pos = global_position
var direct = 1
var reset = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = current_pos
	if get_parent().special_powers:
		
		if not reset:
			current_pos.x += 30 * direct
			if direct == 0:
				current_pos = self.get_parent().position
				reset = true
		else:
			reset = false
			var ani = self.get_parent().get_children()[2].animation
			
			if ani == 'left':
				direct = -1
			elif ani == 'right':
				direct = 1
			else:
				direct = 0
			current_pos = self.get_parent().position
	else:
		current_pos = self.get_parent().position
		


func _on_body_entered(body):
	reset = true
	if body.name == 'CharacterBody2D':
		Global.filled -= 1
