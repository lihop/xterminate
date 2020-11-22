tool
extends Spatial


export var text := ""
export var highlight := false setget set_highlight


func _ready():
	$Label3D.text = text


func set_highlight(should_highlight: bool) -> void:
	if should_highlight != highlight:
		highlight = should_highlight
		$Label3D.emission_strength = 1 if highlight else 0
