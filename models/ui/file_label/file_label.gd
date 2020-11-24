tool
extends "res://addons/SIsilicon.3d.text/label_3d.gd"


export var billboard := false setget set_billboard


func _ready():
	if billboard and material:
		material.set_shader_param("billboard", billboard)


func set_billboard(value: bool) -> void:
	billboard = value
	if material:
		material.set_shader_param("billboard", value)
