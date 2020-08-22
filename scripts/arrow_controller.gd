extends Node2D

var flash_message = preload("res://flash_message.tscn")
onready var up_arrow = get_node("up_arrow_outline")
onready var down_arrow = get_node("down_arrow_outline")
onready var right_arrow = get_node("right_arrow_outline")
onready var left_arrow = get_node("left_arrow_outline")
onready var rhythm_controller = get_parent().get_node("rhythm_controller")

var ORIG_SCALE = Vector2(2.0, 2.0)
var SCALE_FACTOR = Vector2(2.5, 2.5)
var SCALE_SPEED = 20

# maximum distance a moving arrow will be counted as a "hit"
var ARROW_DIST_PERFECT:float = 1.5
var ARROW_DIST_GREAT:float = 2.0
var ARROW_DIST_GOOD:float = 5.0
var ARROW_DIST_MISS:float = 20.0

enum Hit {
	MISS = 0,
	GOOD = 1,
	GREAT = 2,
	PERFECT = 3
}

var scores = {
	Hit.PERFECT: 0,
	Hit.GREAT: 0,
	Hit.GOOD: 0,
	Hit.MISS: 0
}


func _process(delta):
	if Input.is_action_pressed("ui_up"):
		up_arrow.scale = up_arrow.scale.linear_interpolate(SCALE_FACTOR, SCALE_SPEED * delta)
	else:
		up_arrow.scale = up_arrow.scale.linear_interpolate(ORIG_SCALE, SCALE_SPEED * delta)

	if Input.is_action_pressed("ui_down"):
		down_arrow.scale = down_arrow.scale.linear_interpolate(SCALE_FACTOR, SCALE_SPEED * delta)
	else:
		down_arrow.scale = down_arrow.scale.linear_interpolate(ORIG_SCALE, SCALE_SPEED * delta)

	if Input.is_action_pressed("ui_right"):
		right_arrow.scale = right_arrow.scale.linear_interpolate(SCALE_FACTOR, SCALE_SPEED * delta)
	else:
		right_arrow.scale = right_arrow.scale.linear_interpolate(ORIG_SCALE, SCALE_SPEED * delta)

	if Input.is_action_pressed("ui_left"):
		left_arrow.scale = left_arrow.scale.linear_interpolate(SCALE_FACTOR, SCALE_SPEED * delta)
	else:
		left_arrow.scale = left_arrow.scale.linear_interpolate(ORIG_SCALE, SCALE_SPEED * delta)


func _input(event):
	var hits = []
	var last_hit = null
	
	if event.is_action_pressed("ui_up"):
		var ups = rhythm_controller.arrows["up"]
		last_hit = handle_arrow_hit(up_arrow.global_position, ups)
		if last_hit:
			hits.append(last_hit)

	if event.is_action_pressed("ui_down"):
		var downs = rhythm_controller.arrows["down"]
		last_hit = handle_arrow_hit(down_arrow.global_position, downs)
		if last_hit:
			hits.append(last_hit)

	if event.is_action_pressed("ui_right"):
		var rights = rhythm_controller.arrows["right"]
		last_hit = handle_arrow_hit(right_arrow.global_position, rights)
		if last_hit:
			hits.append(last_hit)

	if event.is_action_pressed("ui_left"):
		var lefts = rhythm_controller.arrows["left"]
		last_hit = handle_arrow_hit(left_arrow.global_position, lefts)
		if last_hit:
			hits.append(last_hit)

	# only create a flash message for the last hit, so multiple messages don't overlap
	# it's a lazy but easy solution
	if last_hit:
		create_flash_message(last_hit)

	# increment the score for each hit type
	for h in hits:
		scores[h] += 1

func handle_arrow_hit(target:Vector2, arrows:Array):
	for a in arrows:
		var dist = target.distance_to(a.global_position)
		print(dist)
		var hit = null
		
		if dist <= ARROW_DIST_PERFECT:
			hit = Hit.PERFECT
		elif dist <= ARROW_DIST_GREAT:
			hit = Hit.GREAT
		elif dist <= ARROW_DIST_GOOD:
			hit = Hit.GOOD
		elif dist <= ARROW_DIST_MISS:
			hit = Hit.MISS
		
		if hit:
			a.queue_free()
			arrows.erase(a)
		
		# there should only ever be one hit per column at a time
		# don't need to keep looping
		return hit

func create_flash_message(hit):
	var msg = flash_message.instance()
	if hit == Hit.PERFECT:
		msg.type = "perfect"
	elif hit == Hit.GREAT:
		msg.type = "great"
	elif hit == Hit.GOOD:
		msg.type = "good"
	elif hit == Hit.MISS:
		msg.type = "miss"
	get_parent().add_child(msg)
