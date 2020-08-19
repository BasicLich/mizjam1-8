extends Control

var delay_timer

onready var music = get_node("background_music")


func _ready():
	music.volume_db = -40
	music.play()

	var tween_in = get_node("Tween")
	tween_in.interpolate_property(music, "volume_db", -40, -8, 2.5, 1, Tween.EASE_IN, 0)
	tween_in.start()


func _on_play_button_pressed():
	var tween_out = get_node("Tween")
	tween_out.interpolate_property(music, "volume_db", -8, -30, 8.0, 1, Tween.EASE_OUT, 0)
	tween_out.start()
	
	$main_menu.visible = false
	$instructions.visible = true
	
	# show the instructions for 8 seconds
	delay_timer = Timer.new()
	delay_timer.wait_time = 8.0
	delay_timer.autostart = true
	delay_timer.one_shot = true
	delay_timer.connect("timeout", self, "start_game")
	add_child(delay_timer)


func _on_exit_button_pressed():
	get_tree().quit()


func _input(event):
	# any key press starts the game from the instructions screen
	if $instructions.visible and event is InputEventKey and event.pressed:
		start_game()


func start_game():
	get_tree().change_scene("res://game_root.tscn")


func _on_play_button_mouse_entered():
	$main_menu/play_button/selected.visible = true


func _on_play_button_mouse_exited():
	$main_menu/play_button/selected.visible = false


func _on_exit_button_mouse_entered():
	$main_menu/exit_button/selected.visible = true


func _on_exit_button_mouse_exited():
	$main_menu/exit_button/selected.visible = false
