tool
extends Control
# This scene demonstrates how we can control the Terminal node directly by
# sending and receiving strings and ANSI escape sequences to the terminal
# directly.

# References:
# - https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html
# - https://www.youtube.com/watch?v=jTSQlIK_92w

signal starting_game()

# Title generated using command: toilet -f pagga GODOT XTERM
const TITLE = """
░█░█░▀█▀░█▀▀░█▀▄░█▄█░▀█▀░█▀█░█▀█░▀█▀░█▀▀\r
░▄▀▄░░█░░█▀▀░█▀▄░█░█░░█░░█░█░█▀█░░█░░█▀▀\r
░▀░▀░░▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀\r
"""
const TITLE_WIDTH = 42

var menu_items := [
	{ "name": "Play" },
	{ "name": "Quit" },
]

var selected_index := 0

var row: int
var menu_start_row: int
var offset: int

onready var tput = TPut.new($Terminal)


func _ready():
	# warning-ignore:return_value_discarded
	$Terminal.connect("size_changed", self, "draw_all")
	$Terminal.grab_focus()
	draw_all()


func draw_all(_size = Vector2.ZERO):
	offset = int(floor(($Terminal.cols / 2.0) - (TITLE_WIDTH / 2.0)))
	tput.reset()
	row = 5
	tput.civis() # Hide the cursor.
	draw_title()
	draw_menu()
	tput.sgr0()
	row += 1


func draw_title():
	tput.cup(row, 0)
	
	for line in TITLE.split("\r"):
		row += 1
		tput.cup(row, offset)
		$Terminal.write(line)
	
	# Get the plugin version from the plugin's config file.
	var config = ConfigFile.new()
	var err = config.load("res://addons/godot_xterm/plugin.cfg")
	if err == OK:
		$Terminal.write("\n")
		$Terminal.write("Version: 0.0.0-alpha.0")
	row += 2


func draw_menu():
	if not menu_start_row:
		menu_start_row = row + 1
	
	row = menu_start_row
	
	var col_offset: int
	
	for i in range(menu_items.size()):
		row += 1
		var item = menu_items[i]
		
		if not col_offset:
			col_offset = int(floor(($Terminal.cols / 2) - (item.name.length() / 2)))
		
		tput.cup(row, offset)
		
		if selected_index == i:
			tput.setab(Color("#FF0000"))
			tput.setaf(Color.green)
		
		$Terminal.write("%s. %s" % [i + 1, item.name])
		
		if selected_index == i:
			tput.sgr0()
	
	row += 2
	tput.cup(row, 0)
	$Terminal.write('"Canon In D For 8 Bit Synths" by Kevin Macleod, from https://incompetech.filmmusic.io/song/6956-canon-in-d-for-8-bit-synths, released under CC-BY 4.0.')
	row += 3
	tput.cup(row, 0)
	$Terminal.write('"Concentration" by Kevin Macleod, from https://incompetech.filmmusic.io/song/3536-concentration, released under CC-BY 4.0.')
	row += 3
	tput.cup(row, 0)
	$Terminal.write('"Running on Ground" by Disagree, from https://freesound.org/people/Disagree/sounds/433725/, released under CC-BY 3.0.')
	row += 3
	tput.cup(row, 0)
	$Terminal.write('"Animated Human Low Poly" by quaternius, from https://opengameart.org/content/animated-human-low-poly, releasend under CC-0.')


func _on_Terminal_key_pressed(data: String, event: InputEventKey) -> void:
	match(data):
		TPut.CURSOR_UP: # Up arrow key
			selected_index = int(clamp(selected_index - 1, 0, menu_items.size() - 1))
			draw_menu()
		TPut.CURSOR_DOWN: # Down arrow key
			selected_index = int(clamp(selected_index + 1, 0, menu_items.size() - 1))
			draw_menu()
		"1":
			selected_index = 0
			draw_menu()
		"2":
			selected_index = 1
			draw_menu()
		"3":
			selected_index = 2
			draw_menu()
	
	# We can also match against the raw InputEventKey.
	if event.scancode == KEY_ENTER:
		var item = menu_items[selected_index]
		
		match item.name:
			"Play":
				emit_signal("starting_game")
				SceneChanger.change_scene("res://scenes/level_1/level_1.tscn")
			"Terminal":
				if OS.get_name() == "Windows":
					return OS.call_deferred("alert", "Psuedoterminal node currently"
							+ " uses pty.h but needs to use either winpty or conpty"
							+ " to work on Windows.", "Terminal not Supported on Windows")
				var scene = item.scene.instance()
				var pty = scene.get_node("Pseudoterminal")
				get_tree().get_root().add_child(scene)
				visible = false
				scene.grab_focus()
				yield(pty, "exited")
				visible = true
				$Terminal.grab_focus()
				scene.queue_free()
			"Quit":
				get_tree().quit()


func _on_Asciicast_key_pressed(data: String, _event: InputEventKey,
		animation_player: AnimationPlayer) -> void:
	if data == "\u001b":
		animation_player.emit_signal("animation_finished")
