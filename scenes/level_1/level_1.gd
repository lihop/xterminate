extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.stream = ResourceLoader.load("res://scenes/level_1/concentration.ogg")
	MusicPlayer.play()


func _on_BackArea_body_entered(body: KinematicBody):
	if body and body.is_in_group("Players"):
		SceneChanger.change_scene("res://scenes/level_2/level_2.tscn")


func _on_Area_body_entered(body):
	if body.is_in_group("Players"):
		$Player/MovementHints.visible = false
