extends KinematicBody2D

export var SPEED = 30
export var MAX_FOLLOW_DIST = 150
export var TEMPO = 120
export var TOTAL_BEATS = 20

var follow:bool = false
var follow_body = null

signal start_rhythm_mode(enemy, player)


func _ready():
	# this will exist when the scene is added to the game scene
	var game = get_tree().get_root().get_node("game_root")
	connect("start_rhythm_mode", game, "_on_start_rhythm_mode")


func _physics_process(delta):
	if follow:
		var dist = position.distance_to(follow_body.position)
		
		if dist >= MAX_FOLLOW_DIST:
			follow = false
			return

		var move = position.direction_to(follow_body.position) * SPEED
		move_and_slide(move)

		for i in get_slide_count():
			var collision = get_slide_collision(i)

			if collision and collision.collider_id == follow_body.get_instance_id():
				follow = false
				call_deferred("emit_signal", "start_rhythm_mode", self, follow_body)
				return


func _on_detect_area_body_entered(body):
	if body.name == "player":
		follow = true
		follow_body = body
