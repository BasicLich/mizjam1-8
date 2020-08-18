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
var ARROW_DIST_PERFECT:float = 1.0
var ARROW_DIST_GREAT:float = 1.6
var ARROW_DIST_GOOD:float = 5.0
var ARROW_DIST_MISS:float = 20.0

enum Hit {
	MISS,
	GOOD,
	GREAT,
	PERFECT
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
	
	if event.is_action_pressed("ui_up"):
		var ups = rhythm_controller.arrows["up"]
		var hit = handle_arrow_hit(up_arrow.global_position, ups)
		if hit:
			hits.append(hit)

	if event.is_action_pressed("ui_down"):
		var downs = rhythm_controller.arrows["down"]
		var hit = handle_arrow_hit(down_arrow.global_position, downs)
		if hit:
			hits.append(hit)

	if event.is_action_pressed("ui_right"):
		var rights = rhythm_controller.arrows["right"]
		var hit = handle_arrow_hit(right_arrow.global_position, rights)
		if hit:
			hits.append(hit)

	if event.is_action_pressed("ui_left"):
		var lefts = rhythm_controller.arrows["left"]
		var hit = handle_arrow_hit(left_arrow.global_position, lefts)
		if hit:
			hits.append(hit)

	# TODO score hits here

func handle_arrow_hit(target:Vector2, arrows:Array):
	for a in arrows:
		var dist:float = target.distance_to(a.global_position)
		var hit = null
		
		if dist <= ARROW_DIST_PERFECT:
			hit = Hit.PERFECT
			var msg = flash_message.instance()
			msg.type = "perfect"
			get_parent().add_child(msg)
		elif dist <= ARROW_DIST_GREAT:
			hit = Hit.GREAT
			var msg = flash_message.instance()
			msg.type = "great"
			get_parent().add_child(msg)
		elif dist <= ARROW_DIST_GOOD:
			hit = Hit.GOOD
			var msg = flash_message.instance()
			msg.type = "good"
			get_parent().add_child(msg)
		elif dist <= ARROW_DIST_MISS:
			hit = Hit.MISS
			var msg = flash_message.instance()
			msg.type = "miss"
			get_parent().add_child(msg)
		
		if hit:
			a.queue_free()
			arrows.erase(a)
		
		return hit
