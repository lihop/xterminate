extends GridMap

const START_OFFSET = Vector3(0, -50, 0)


func _init():
	visible = true


func _ready():
	return
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var used_cells := get_used_cells()
	while not used_cells.empty():
		yield(get_tree().create_timer(rng.randf_range(0.05, 0.1)), "timeout")
		var cell = used_cells.pop_back()
		var mesh_instance = MeshInstance.new()
		var item = get_cell_item(cell.x, cell.y, cell.z)
		mesh_instance.mesh = mesh_library.get_item_mesh(item)
		if cell_center_x:
			cell.x += cell_size.x / 2
		if cell_center_y:
			cell.y += cell_size.y / 2
		if cell_center_z:
			cell.z += cell_size.z / 2
		var tween = Tween.new()
		tween.interpolate_property(mesh_instance, "translation",
				cell + START_OFFSET + Vector3(
					rng.randf_range(-5, 5),
					rng.randf_range(-5, 5),
					rng.randf_range(-5, 5)
				), cell, rng.randf_range(1, 3),
				Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		mesh_instance.add_child(tween)
		mesh_instance.translation = cell + START_OFFSET
		get_parent().add_child(mesh_instance)
		tween.start()
