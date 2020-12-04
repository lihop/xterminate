extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_EndArea_body_entered(body: KinematicBody):
	if body and body.is_in_group("Players"):
		MusicPlayer.stop()
		SceneChanger.change_scene("res://scenes/main_menu/main_menu.tscn")
