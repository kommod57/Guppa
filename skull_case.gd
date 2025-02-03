extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D/AnimatedSprite2D.play()
	$CollisionShape2D/AnimatedSprite2D.animation = 'off'
	if Global.level == 20 and (Global.natural_level_progession >= 0.2):
		$CollisionShape2D.position = Vector2(300,460)
		if Global.natural_level_progession > 0.2:
			$CollisionShape2D/AnimatedSprite2D.animation = 'on'
	else:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	



func _on_skull_case_body_entered(body):
	if body.name == 'Flowa':
		if body.get_children()[3].visible:
			await get_tree().create_timer(0.2).timeout
			$CollisionShape2D/AnimatedSprite2D.animation = 'on'
			if Global.level == 20:
				Global.natural_level_progession = 0.3
