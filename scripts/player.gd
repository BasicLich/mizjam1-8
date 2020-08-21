extends KinematicBody2D

export var MOVE_SPEED = 100

var moving = false


func _process(delta):
	if moving:
		var ticks = OS.get_ticks_msec() / (MOVE_SPEED / 2)
		$Sprite.rotation = sin(ticks) / 4
	else:
		$Sprite.rotation = 0


func _physics_process(_delta):
	moving = false
	var velocity = Vector2(0, 0)
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2(0, -1) * MOVE_SPEED
		moving = true
	elif Input.is_action_pressed("ui_down"):
		velocity += Vector2(0, 1) * MOVE_SPEED
		moving = true
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2(1, 0) * MOVE_SPEED
		moving = true
	elif Input.is_action_pressed("ui_left"):
		velocity += Vector2(-1, 0) * MOVE_SPEED
		moving = true

	move_and_slide(velocity)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		
		if collision.collider.name == "dog":
			get_tree().change_scene("res://ending.tscn")
