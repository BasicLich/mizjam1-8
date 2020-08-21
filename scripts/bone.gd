extends Area2D

func _on_bone_body_entered(body):
	if body.name == "player":
		global.bones_collected += 1
		
		visible = false
		queue_free()
