extends KinematicBody2D

var spawns = [
	Vector2(-34, 87), # maze
	Vector2(71, 82), # lake island
	Vector2(184, 69), # tree alcove
	Vector2(45, 95), # lake shore
	Vector2(157, 124), # garden
	Vector2(62, -36) # town square
]
var rng


func rand_choice(choices):
	var index = rng.randi_range(0, len(choices) - 1)
	return choices[index]


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var spawn = rand_choice(spawns)
	position = get_parent().get_node("map/ground").map_to_world(spawn)
	print("DOG SPAWN: ", spawn)
