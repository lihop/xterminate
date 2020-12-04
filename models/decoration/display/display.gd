tool
extends Spatial


export var theme: Theme setget set_theme


func set_theme(value: Theme) -> void:
	theme = value
	$Viewport/Terminal.theme = theme
