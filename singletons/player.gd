extends Node


signal entered_insert_mode()
signal entered_move_mode()


enum ConsoleModes {
	MOVE,
	INSERT,
}
const CONSOLE_MODE_MOVE := ConsoleModes.MOVE
const CONSOLE_MODE_INSERT := ConsoleModes.INSERT

var console_mode := CONSOLE_MODE_MOVE setget set_console_mode
var speed := 5

var prompt := "\u001b[0;32m[player@godot]$ \u001b[0m"


func set_console_mode(mode: int) -> void:
	if console_mode != mode:
		console_mode = mode
		match console_mode:
			CONSOLE_MODE_INSERT:
				emit_signal("entered_insert_mode")
			CONSOLE_MODE_MOVE:
				emit_signal("entered_move_mode")
