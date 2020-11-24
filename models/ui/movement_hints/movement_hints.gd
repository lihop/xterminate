extends Spatial


func _input(event: InputEvent) -> void:
	if Player.console_mode != Player.CONSOLE_MODE_MOVE:
		return
	
	for direction in ["Up", "Down", "Left", "Right"]:
		var action = "move_%s" % direction.to_lower()
		var arrow = get_node(direction)
		var label = get_node("%s/Label" % direction)
		
		if event.is_action_pressed(action):
			label.highlight = true
			arrow.highlight = true
			break
		elif event.is_action_released(action):
			label.highlight = false
			arrow.highlight = false
			break
