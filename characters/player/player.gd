extends KinematicBody


const ACCELERATION := 10
const DECELERATION := 20

var gravity := Vector3.DOWN * 0.1
var velocity := Vector3.ZERO
var time := 0.0


func _physics_process(delta: float) -> void:
	var speed = Player.speed
	var direction = Vector3.ZERO
	var is_moving := false
	
	if Player.console_mode == Player.CONSOLE_MODE_MOVE:
		if Input.is_action_pressed("move_left") and $RayCastLeft.is_colliding():
			direction -= transform.basis.x
			is_moving = true
		if Input.is_action_pressed("move_right") and $RayCastRight.is_colliding():
			direction += transform.basis.x
			is_moving = true
		if Input.is_action_pressed("move_up") and $RayCastForward.is_colliding():
			direction -= transform.basis.z
			is_moving = true
		if Input.is_action_pressed("move_down") and $RayCastBackward.is_colliding():
			direction += transform.basis.z
			is_moving = true
	
	if is_moving and not $FootstepsPlayer.playing:
		$FootstepsPlayer.play()
	elif $FootstepsPlayer.playing and not is_moving:
		$FootstepsPlayer.stop()
	
	if not $RayCastForward.is_colliding():
		direction += transform.basis.z
	if not $RayCastBackward.is_colliding():
		direction -= transform.basis.z
	if not $RayCastLeft.is_colliding():
		direction += transform.basis.x
	if not $RayCastRight.is_colliding():
		direction -= transform.basis.x

	direction = direction.normalized()
	var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
	var acceleration = ACCELERATION if direction.dot(horizontal_velocity) > 0 else DECELERATION
	
	var new_position = direction * speed
	horizontal_velocity = horizontal_velocity.linear_interpolate(new_position, acceleration * delta)
	
	#var down = 0 if is_on_floor() else -1
	velocity = Vector3(horizontal_velocity.x, velocity.y, horizontal_velocity.z)
	velocity = move_and_slide(velocity, Vector3.UP)
	
	var h_velocity = horizontal_velocity
	
	if is_moving:
		var angle = atan2(h_velocity.x, h_velocity.z)
		$Model.rotation.y = angle
	
	if Player.console_mode == Player.CONSOLE_MODE_MOVE:
		time = 0
		var speed_normalized = horizontal_velocity.length() / speed
		$Model/IdleWorkingAnimation.active = false
		$Model/IdleRunAnimation.active = true
		$Model/IdleRunAnimation.blend2_node_set_amount("IdleRun", speed_normalized)
	elif Player.console_mode == Player.CONSOLE_MODE_INSERT:
		time += (delta * 4)
		$Model/IdleRunAnimation.active = false
		$Model/IdleWorkingAnimation.active = true
		$Model/IdleWorkingAnimation.blend2_node_set_amount("IdleWorking", min(time, 1))


func _input(event: InputEvent) -> void:
	match Player.console_mode:
		Player.CONSOLE_MODE_INSERT:
			if event.is_action_pressed("console_mode_move"):
				Player.console_mode = Player.CONSOLE_MODE_MOVE
				$Model/Laptop.visible = false
		Player.CONSOLE_MODE_MOVE, _:
			if event.is_action_pressed("console_mode_insert"):
				Player.console_mode = Player.CONSOLE_MODE_INSERT
				$Model/Laptop.visible = true
