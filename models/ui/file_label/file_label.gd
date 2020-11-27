extends Position3D


func _ready():
	var parent = get_parent()
	if parent is PosixFile:
		set_process(true)
	else:
		set_process(false)


func _process(_delta):
	var camera := get_viewport().get_camera()
	if camera:
		$Label.position = camera.unproject_position(transform.origin)
