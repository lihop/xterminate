extends Control


var buffer := ""

var parser := CommandParser.new()
var commands := BashLikeCommands.new()
var awaiting_confirmation := false


onready var app = $App
onready var terminal = $Panel/Terminal


func format_date_time():
	# Code in this function by jospic (https://godotengine.org/qa/user/jospic)
	# Copied from https://godotengine.org/qa/19077/how-to-get-the-date-as-per-rfc-1123-date-format-in-game
	var time = OS.get_datetime()
	var nameweekday= ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	var namemonth= ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var dayofweek = time["weekday"]
	var day = time["day"]
	var month= time["month"]
	var year= time["year"]             
	var hour= time["hour"]
	var minute= time["minute"]
	var second= time["second"]
	var dateRFC1123 = str(nameweekday[dayofweek]) + ", " + str("%02d" % [day]) + " " + str(namemonth[month-1]) + " " + str(year) + " " + str("%02d" % [hour]) + ":" + str("%02d" % [minute]) + ":" + str("%02d" % [second]) + " GMT"
	return dateRFC1123


func send_ctrl_c():
	var initially_focused = terminal.has_focus()
	var ctrl_c = InputEventKey.new()
	ctrl_c.control = true
	ctrl_c.scancode = KEY_ENTER
	focus_terminal()
	get_tree().input_event(ctrl_c)
	if not initially_focused:
		unfocus_terminal()


func message(message: String, user := "root", host := "godot", term := "tty/0"):
	var time = OS.get_time()
	
	pause()
	get_tree().paused = true
	
	# Send a ctrl-c to cancel anything in the terminal.
	send_ctrl_c()
	terminal.write("\r\n\r\n")
	terminal.write("Broadcast message from %s@%s (%s) (%s):" \
			% [user, host, term, format_date_time()])
	terminal.write("\r\n\r\n")
	terminal.write(message)
	terminal.write("\r\n")


func _ready():
	Player.connect("entered_move_mode", self, "_on_player_entered_move_mode", [], CONNECT_DEFERRED)
	Player.connect("entered_insert_mode", self, "_on_player_entered_insert_mode", [], CONNECT_DEFERRED)


func _on_player_entered_insert_mode():
	focus_terminal()


func focus_terminal():
	terminal.focus_mode = FOCUS_ALL
	terminal.grab_focus()


func _on_player_entered_move_mode():
	unfocus_terminal()


func unfocus_terminal():
	terminal.release_focus()
	terminal.focus_mode = FOCUS_NONE


func _on_Terminal_data_sent(data: PoolByteArray):
	return
#	var string = data.get_string_from_utf8()
#
#	match string:
#		"\t":
#			pass # TODO auto-completion
#		"\b":
#			if not buffer.empty():
#				buffer.erase(buffer.length() - 1, 1)
#				terminal.write("\b\u001b[K")
#		"\r\n":
#			terminal.write("\r\n")
#			var result := parser.tokenize(buffer)
#			buffer.erase(0, buffer.length())
#			print(result)
#			var stdout := parser.execute(result, [self, commands], "%s\r\n")
#			terminal.write(stdout)
#			terminal.write("\r\n")
#		_:
#			terminal.write(string)
#			buffer += string


func _on_Terminal_key_pressed(_data, event: InputEventKey):
	if Player.console_mode != Player.CONSOLE_MODE_INSERT:
		return
#
#	if event.scancode == KEY_ENTER:
#		print('enter pressed')

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("continue") and awaiting_confirmation:
		unpause()


func pause() -> void:
	material.set_shader_param("on", true)
	get_tree().paused = true
	awaiting_confirmation = true


func unpause() -> void:
	awaiting_confirmation = false
	get_tree().paused = false
	material.set_shader_param("on", false)
