extends Control


onready var tween = $Tween


func _on_Menu_starting_game():
	tween.interpolate_property($AudioStreamPlayer, "volume_db", 0, -80, 1, tween.TRANS_SINE, tween.EASE_IN)
	tween.start()
