tool
extends CSGCombiner


export var highlight := false setget set_highlight

var base_material: SpatialMaterial
var highlight_material: SpatialMaterial

func _ready():
	base_material = $CSGBox.material
	highlight_material = base_material.duplicate()
	highlight_material.emission_energy = 1


func set_highlight(should_highlight: bool) -> void:
	if highlight != should_highlight:
		highlight = should_highlight
		for child in get_children():
			if child is CSGShape:
				child.material = highlight_material if highlight else base_material
