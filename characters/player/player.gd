extends KinematicBody


var gravity := Vector3.DOWN * 0.1
var velocity := Vector3.ZERO


func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity.y = 0
	else:
		velocity += gravity * delta
	
	var velocity_y = velocity.y
	var velocity = Vector3.ZERO
	var speed = Player.speed
	
	if Input.is_action_pressed("move_left") and $RayCastLeft.is_colliding():
		velocity -= transform.basis.x * speed
	if Input.is_action_pressed("move_right") and $RayCastRight.is_colliding():
		velocity += transform.basis.x * speed
	if Input.is_action_pressed("move_up") and $RayCastForward.is_colliding():
		velocity -= transform.basis.z * speed
	if Input.is_action_pressed("move_down") and $RayCastBackward.is_colliding():
		velocity += transform.basis.z * speed
	
	velocity.y = velocity_y
	velocity = move_and_slide(velocity, Vector3.UP)
	
	var angle = atan2(velocity.x, velocity.y)
	var char_rot = $"Animated Human".get_rotation()
	char_rot.y = angle
	$"Animated Human".set_rotation(char_rot)


func _input(event: InputEvent) -> void:
	match Player.console_mode:
		Player.CONSOLE_MODE_INSERT:
			if event.is_action_pressed("console_mode_move"):
				Player.console_mode = Player.CONSOLE_MODE_MOVE
				set_physics_process(true)
		Player.CONSOLE_MODE_MOVE, _:
			if event.is_action_pressed("console_mode_insert"):
				set_physics_process(true)
				Player.console_mode = Player.CONSOLE_MODE_INSERT
