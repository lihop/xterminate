extends Spatial


#func _ready():
#	Player.connect("entered_insert_mode", self, "_on_player_entered_insert_mode", [], CONNECT_ONESHOT)


func _on_Area_body_entered(body):
	$Hint.show()
#
#
#func _on_player_entered_insert_mode():
#	$Hint2.hint_text = "Use the 'ls' command to list files in the current directory.\r\nUse the 'rm' command to delete theme.\r\nPress 'Esc'to return to move mode."
#	$Hint2.show()


func _on_BackArea_body_entered(body: KinematicBody):
	if body and body.is_in_group("Players"):
		SceneChanger.change_scene("res://levels/level_2/level2.tscn")
