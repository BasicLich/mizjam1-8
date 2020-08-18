extends Node2D

export var TEMPO = 120
export var TOTAL_BEATS = 20


func _ready():
	# this will exist when the scene is added to the game scene
	var game = get_tree().get_root().get_node("game_root")
	var rhythm_controller = get_node("rhythm_controller")
	rhythm_controller.connect("rhythm_complete", game, "_on_rhythm_complete")
