extends Node2D

var rhythm_game = preload("res://rhythm_game.tscn")


func _ready():
	global.total_bones = $world/bones.get_child_count()


func _on_start_rhythm_mode(enemy, player):
	var rhythm_inst = rhythm_game.instance()
	rhythm_inst.TEMPO = enemy.TEMPO
	rhythm_inst.TOTAL_BEATS = enemy.TOTAL_BEATS
	var char_left = rhythm_inst.get_node("char_left")
	var char_right = rhythm_inst.get_node("char_right")
	char_left.texture = player.get_node("Sprite").texture
	char_right.texture = enemy.get_node("Sprite").texture
	
	# temporarily remove the world scene from the tree
	var world = get_node("world")
	remove_child(world)
	global.world_scene = world
	
	enemy.queue_free()
	add_child(rhythm_inst)


func _on_rhythm_complete(rhythm_inst):
	remove_child(rhythm_inst)
	var world = global.world_scene
	add_child(world)
	
	global.world_scene = null
	rhythm_inst.queue_free()
	
	if global.lose:
		get_tree().change_scene("res://ending.tscn")
