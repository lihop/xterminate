tool
extends Spatial


export(String, MULTILINE) var hint_text := ""
export var pixel_size := 0.1 setget set_pixel_size
export var auto_show := true

var rng = RandomNumberGenerator.new()

onready var terminal = $Viewport/Terminal


func set_pixel_size(value: float) -> void:
	pixel_size = value
	$Screen.pixel_size = pixel_size


func _ready():
	if auto_show:
		show()


func show():
	rng.randomize()
	terminal.write("\u001bc")
	hint_text = hint_text.replace("\n", "\r\n")
	type(hint_text)


func type(text: String) -> void:
	for c in text:
		var delay = rng.randf_range(0.05, 0.03)
		terminal.write(c)
		yield(get_tree().create_timer(delay), "timeout")
