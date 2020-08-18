extends Control

onready var music = get_node("background_music")


func _ready():
	music.volume_db = -40
	music.play()

	var tween_in = get_node("Tween")
	tween_in.interpolate_property(music, "volume_db", -40, -8, 2.5, 1, Tween.EASE_IN, 0)
	tween_in.start()


func _on_play_button_pressed():
	var tween_out = get_node("Tween")
	tween_out.interpolate_property(music, "volume_db", -8, -40, 2.5, 1, Tween.EASE_OUT, 0)
	tween_out.start()
	
	get_tree().change_scene("res://game_root.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
