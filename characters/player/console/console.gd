extends Control

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
	$Terminal.write("\r\n")
	$Terminal.write("Broadcast message from %s@%s (%s) (%s):" \
			% [user, host, terminal, format_date_time()])
	$Terminal.write("\r\n\r\n")
	$Terminal.write(message)
	$Terminal.write("\r\n")
	# TODO: Start repl.
