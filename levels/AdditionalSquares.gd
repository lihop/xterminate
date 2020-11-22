extends GridMap


const START_OFFSET = Vector3(0, -50, 0)

signal tweens_completed()

var rng: RandomNumberGenerator
var collision_mask_saved: int
var collision_layer_saved: int
var tween_count := 0

func _init():
	visible = false
	collision_mask_saved = collision_mask
	collision_mask = 0
	collision_layer_saved = collision_layer
	collision_layer = 0


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func _on_tween_completed(_object, _path):
	tween_count -= 1
	if tween_count < 5:
		emit_signal("tweens_completed")

func transition_in():
	var used_cells := get_used_cells()
	tween_count = used_cells.size()
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
				), cell, rng.randf_range(0.5, 1),
				Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		mesh_instance.add_child(tween)
		mesh_instance.translation = cell + START_OFFSET
		get_parent().add_child(mesh_instance)
		tween.connect("tween_completed", self, "_on_tween_completed")
		tween.start()
	yield(self, "tweens_completed")
	visible = true
	collision_layer = collision_layer_saved
	collision_mask = collision_mask_saved
	for child in get_children():
		child.free()
