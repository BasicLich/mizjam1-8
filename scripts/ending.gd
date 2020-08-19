extends Node2D

func _ready():
	if global.lose:
		$game_over.visible = true
	else:
		$you_win.visible = true
		$dog.visible = true

	get_node("bones_collected/Label").text = str(global.bones_collected)
	get_node("beats/perfect/Label").text = str(global.total_perfects)
	get_node("beats/great/Label").text = str(global.total_greats)
	get_node("beats/good/Label").text = str(global.total_goods)
	get_node("beats/miss/Label").text = str(global.total_misses)
