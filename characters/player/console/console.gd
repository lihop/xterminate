extends Control


var buffer := ""

var parser := CommandParser.new()
var commands := BashLikeCommands.new()


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


func message(message: String, user := "root", host := "godot", terminal := "tty/0"):
	var time = OS.get_time()
	
	# TODO: Stop repl.
	$Terminal.write("\r\n\r\n")
	$Terminal.write("Broadcast message from %s@%s (%s) (%s):" \
			% [user, host, terminal, format_date_time()])
	$Terminal.write("\r\n\r\n")
	$Terminal.write(message)
	$Terminal.write("\r\n")
	prompt()
	$Terminal.write(buffer)


func _ready():
	$Terminal.write("\u001b[20h")
	Player.connect("entered_move_mode", self, "_on_player_entered_move_mode", [], CONNECT_DEFERRED)
	Player.connect("entered_insert_mode", self, "_on_player_entered_insert_mode", [], CONNECT_DEFERRED)
	prompt()


func _on_player_entered_insert_mode():
	$Terminal.focus_mode = FOCUS_ALL
	$Terminal.grab_focus()


func _on_player_entered_move_mode():
	$Terminal.release_focus()
	$Terminal.focus_mode = FOCUS_NONE


func prompt(prompt := Player.prompt) -> void:
	$Terminal.write(prompt)


func _on_Terminal_data_sent(data: PoolByteArray):
	var string = data.get_string_from_utf8()
	
	match string:
		"\t":
			pass # TODO auto-completion
		"\b":
			if not buffer.empty():
				buffer.erase(buffer.length() - 1, 1)
				$Terminal.write("\b\u001b[K")
		"\r\n":
			$Terminal.write("\r\n")
			var result := parser.tokenize(buffer)
			buffer.erase(0, buffer.length())
			print(result)
			var stdout := parser.execute(result, [self, commands], "%s\r\n")
			$Terminal.write(stdout)
			$Terminal.write("\r\n")
			prompt()
		_:
			$Terminal.write(string)
			buffer += string


func _on_Terminal_key_pressed(_data, event: InputEventKey):
	if Player.console_mode != Player.CONSOLE_MODE_INSERT:
		return
#
#	if event.scancode == KEY_ENTER:
#		print('enter pressed')
