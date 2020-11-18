extends Node



enum ConsoleModes {
	MOVE,
	INSERT,
}
const CONSOLE_MODE_MOVE = ConsoleModes.MOVE
const CONSOLE_MODE_INSERT = ConsoleModes.INSERT

var console_mode := CONSOLE_MODE_MOVE
var speed := 5
