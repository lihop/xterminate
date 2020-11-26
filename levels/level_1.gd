extends Spatial


signal continue_level()

onready var console = $Player/Console

var entered_door_area := false


func _ready():
	$Part2.transition_in()
	yield(get_tree().create_timer(3), "timeout")
	console.message("Use 'h' 'j' 'k' 'l' to move\r\n\nPress ENTER to continue")
	$Part3.transition_in()
	$Player/MovementHints.visible = true
	#yield($Part3Trigger, "body_entered")
	#$Part3.transition_in()


func _on_DoorArea_body_entered(body):
	if entered_door_area:
		return
	if body is KinematicBody:
		$Player/MovementHints.queue_free()
		console.message("Press 'i' to enter insert mode\r\n\nPress ENTER to continue")
		yield(Player, "entered_insert_mode")
		print('TODO: Show hint above door')
		entered_door_area = true
		$DoorArea.disconnect("body_entered", self, "_on_DoorArea_body_entered")


