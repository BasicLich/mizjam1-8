extends Node2D

func _ready():
	var bones_message = get_node("bones_message")
	print("Collected " + str(global.bones_collected) + " bones")
