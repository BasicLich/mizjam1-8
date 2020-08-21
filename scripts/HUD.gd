extends Control


func _process(delta):
	$bone_icon/score.text = str(global.bones_collected) + "/" + str(global.total_bones)
