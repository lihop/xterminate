extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var terminal := $Viewport/Terminal


# Called when the node enters the scene tree for the first time.
func _ready():
	terminal.write("Linux is the best")


func _on_FrontArea_body_entered(body: PhysicsBody):
	if body and body.is_in_group("Players"):
		print('player entered the door area')
