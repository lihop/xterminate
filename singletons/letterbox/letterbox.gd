extends Control


var active := false


func show():
	active = true
	focus_mode = FOCUS_ALL
	grab_focus()
	$AnimationPlayer.play("letterbox")


func _input(event):
	handle_input()


func _gui_input(event):
	handle_input()


func _unhandled_input(event):
	handle_input()


func handle_input():
	if active:
		get_tree().set_input_as_handled()


func hide():
	$AnimationPlayer.play_backwards("letterbox")
	yield($AnimationPlayer, "animation_finished")
	release_focus()
	focus_mode = FOCUS_NONE
	active = false
