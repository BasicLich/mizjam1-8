extends Node2D

var TOP_EDGE = -200
var ARROW_HEIGHT = 32.0

var MOVES = {
	# single moves
	"s_left": ["left"],
	"s_down": ["down"],
	"s_up": ["up"],
	"s_right": ["right"],
	# jump moves
	"jump_h": [["left", "right"]],
	"jump_v": [["up", "down"]],
	"jump_ld": [["left", "down"]],
	"jump_lu": [["left", "up"]],
	"jump_rd": [["right", "down"]],
	"jump_ru": [["right", "up"]],
	# walk moves
	"walk_r": ["left", "down", "up", "right"],
	"walk_l": ["right", "up", "down", "left"]
}

enum Hit {
	MISS = 0,
	GOOD = 1,
	GREAT = 2,
	PERFECT = 3
}

var arrows = {
	"left": [],
	"down": [],
	"up": [],
	"right": []
}
var rng
var pixel_per_sec
var delay_timer
var tempo_timer
var scores
var ended = false
var course_arrows = []
var flash_message = preload("res://flash_message.tscn")

onready var arrow_templates = {
	"left": get_node("left_arrow"),
	"down": get_node("down_arrow"),
	"up": get_node("up_arrow"),
	"right": get_node("right_arrow")
}
onready var rhythm_game = get_parent()
onready var char_left = get_parent().get_node("char_left")
onready var char_right = get_parent().get_node("char_right")
onready var dance_chars = [char_left, char_right]

signal rhythm_complete(rhythm_inst)


func _ready():
	# convert BPM to delay in milliseconds
	var ms_per_beat = 60000.0 / rhythm_game.TEMPO
	# figure out how many pixels the arrow will have to move per second at this tempo
	pixel_per_sec = ARROW_HEIGHT / (ms_per_beat / 1000.0)
	
	rng = RandomNumberGenerator.new()
	rng.randomize()

	scores = get_parent().get_node("arrow_controller").scores
	course_arrows = generate_course(rhythm_game.TOTAL_BEATS)
	
	tempo_timer = Timer.new()
	tempo_timer.wait_time = ms_per_beat / 1000.0
	tempo_timer.connect("timeout", self, "tempo_tick")
	add_child(tempo_timer)
	
	delay_timer = Timer.new()
	delay_timer.wait_time = 2.0
	delay_timer.autostart = true
	delay_timer.one_shot = true
	delay_timer.connect("timeout", self, "start_course")
	add_child(delay_timer)


func _process(delta):
	var all_empty = true
	
	for dir in ["left", "down", "up", "right"]:
		for a in arrows[dir]:
			all_empty = false
			a.position.y -= pixel_per_sec * delta

			if a.position.y <= TOP_EDGE:
				a.queue_free()
				arrows[dir].erase(a)

				var msg = flash_message.instance()
				msg.type = "miss"
				get_parent().add_child(msg)
				scores[Hit.MISS] += 1
	
	if all_empty and len(course_arrows) == 0:
		tempo_timer.stop()
		for c in dance_chars:
			c.set_rotation_degrees(0)
		calculate_score()
		
		# wait a while before ending the round
		delay_timer = Timer.new()
		delay_timer.wait_time = 4.0
		delay_timer.autostart = true
		delay_timer.one_shot = true
		delay_timer.connect("timeout", self, "end_course")
		add_child(delay_timer)
		
		# don't call the _process loop anymore
		set_process(false)


func start_course():
	print("COURSE STARTED")
	remove_child(delay_timer)
	tempo_timer.start()


func calculate_score():
	var round_score = get_parent().get_node("round_score")
	
	# yikes this is against DRY but oh well
	global.total_perfects += scores[Hit.PERFECT]
	global.total_greats += scores[Hit.GREAT]
	global.total_goods += scores[Hit.GOOD]
	global.total_misses += scores[Hit.MISS]
	
	round_score.get_node("perfect/score").text = str(scores[Hit.PERFECT])
	round_score.get_node("great/score").text = str(scores[Hit.GREAT])
	round_score.get_node("good/score").text = str(scores[Hit.GOOD])
	round_score.get_node("miss/score").text = str(scores[Hit.MISS])
	round_score.visible = true


func end_course():
	print("COURSE ENDED")
	call_deferred("emit_signal", "rhythm_complete", get_parent())


func tempo_tick():
	# rotate characters back and forth
	# yes I should probably use a sinwave here, but too lazy
	for c in dance_chars:
		if c.rotation_degrees < 0:
			c.set_rotation_degrees(20)
		else:
			c.set_rotation_degrees(-20)

	if len(course_arrows) == 0:
		return

	# setup the next arrows
	var next = course_arrows[0]
	if typeof(next) == TYPE_ARRAY:
		for a in next:
			spawn_arrow(a)
	else:
		spawn_arrow(next)

	course_arrows.remove(0)



func spawn_arrow(direction):
	var arrow = arrow_templates[direction].duplicate(0)
	arrow.visible = true
	arrows[direction].append(arrow)
	add_child(arrow)


func rand_choice(choices):
	var index = rng.randi_range(0, len(choices) - 1)
	return choices[index]


func pick_move():
	var moves = []
	var pick = rng.randi_range(1, 100)
	var count = 1
	
	var is_multi = bool(rng.randi_range(1, 100) <= 20)
	if is_multi:
		count = rng.randi_range(2, 4)
	
	if pick <= 60:
		var m = rand_choice(["s_left", "s_down", "s_up", "s_right"])
		
		for i in count:
			moves.append(m)
	elif pick > 60 and pick <= 80:
		var m = rand_choice(["jump_h", "jump_v", "jump_ld", "jump_lu", "jump_rd", "jump_ru"])
		
		for i in count:
			moves.append(m)
	elif pick > 80:
		var m = rand_choice(["walk_r", "walk_l"])
		
		if count == 1:
			moves.append(m)
		elif count == 2:
			moves.append("walk_l")
			moves.append("walk_l")
		elif count == 3:
			moves.append("walk_r")
			moves.append("walk_r")
		elif count == 4:
			moves.append("walk_l")
			moves.append("walk_r")
	
	return moves


func generate_course(total_beats):
	var course = []
	var cur_beats = 0

	while cur_beats < total_beats:
		var moves = pick_move()
		
		for m in moves:
			for a in MOVES[m]:
				course.append(a)
				cur_beats += 1

	return course
