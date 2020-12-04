extends CanvasLayer


func change_scene(path: String) -> void:
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	print('changing to scene ' + path)
	get_tree().change_scene(path)
	$AnimationPlayer.play_backwards("fade")
