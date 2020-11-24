extends Spatial


signal continue_level()

onready var console = $Player/Console


func _ready():
	$Part2.transition_in()
	yield(get_tree().create_timer(3), "timeout")
	console.message("Use 'h' 'j' 'k' 'l' to move\r\n\nPress ENTER to continue")
	yield(self, "continue_level")
	$Part3.transition_in()
	$Player/MovementHints.visible = true
	#yield($Part3Trigger, "body_entered")
	#$Part3.transition_in()



func _input(event):
	if event.is_action_pressed("continue"):
		print("TODO continue")
		emit_signal("continue_level")


func _on_DoorArea_body_entered(_body):
	console.message("Press 'i' to enter insert mode\r\n\nPress ENTER to continue")
	yield(Player, "entered_insert_mode")
	print('TODO: Show hint above door')


