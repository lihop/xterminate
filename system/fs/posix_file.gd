extends Node
class_name PosixFile

enum {
	# User permissions
	S_IRUSR = 256 # 0400
	S_IWUSR = 128 # 0200
	S_IXUSR = 64 # 0100
	S_IRWXU = S_IRUSR | S_IWUSR | S_IXUSR
	
	# Group permissions
	S_IRGRP = 32 # 040
	S_IWGRP = 16 # 020
	S_IXGRP = 8 # 010
	S_IRWXG = S_IRGRP | S_IWGRP | S_IXGRP
	
	# Others permissions
	S_IROTH = 4 # 04
	S_IWOTH = 2 # 02
	S_IXOTH = 1 # 01
	S_IRWXO = S_IROTH | S_IWOTH | S_IXOTH
	
	# The sticky bit
	S_ISVTX = 512 # 01000
	
	S_IFMT = 61440 # 0170000 file type mask
	S_IFIFO = 4096 # 0010000 named pipe (fifo)
	S_IFCHR = 8192 # 0020000 character special
	S_IFDIR = 16384 # 0040000 directory
	S_IFBLK = 24576 # 0060000 block special
	S_IFREG = 32768 # 0100000 regular
	S_IFLNK = 40960 # 0120000 symbolic link
	S_IFSOCK = 49152 # 0140000 socket
}

enum {
	READ = 1
	WRITE = 2
	EXECUTE = 4
}

enum FileTypes {
	NAMED_PIPE = S_IFIFO
	CHARACTER_SPECIAL = S_IFCHR
	DIRECTORY = S_IFDIR
	BLOCK_SPECIAL = S_IFBLK
	REGULAR = S_IFREG
	SYMBOLIC_LINK = S_IFLNK
	SOCKET = S_IFSOCK
}

var _attributes = S_IFREG | S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH

export var file_name := ""
export var dir_name := ""
var path_name setget ,get_path_name

export var uid := 1000 # player
export var gid := 100 # users

export(int, FLAGS, "Read", "Write", "Execute") var user_permissions := 3 \
		setget set_user_permissions, get_user_permissions

export(int, FLAGS, "Read", "Write", "Execute") var group_permissions := 1 \
		setget set_group_permissions, get_group_permissions

export(int, FLAGS, "Read", "Write", "Execute") var others_permissions := 1 \

export(FileTypes) var file_type := FileTypes.REGULAR setget set_file_type, get_file_type


func set_user_permissions(flags) -> void:
	user_permissions = flags
	set_permissions(flags, S_IRUSR, S_IWUSR, S_IXUSR)

func get_user_permissions() -> int:
	return get_permissions(S_IRUSR, S_IWUSR, S_IXUSR)

func set_group_permissions(flags) -> void:
	group_permissions = flags
	set_permissions(flags, S_IRGRP, S_IWGRP, S_IXGRP)

func get_group_permissions() -> int:
	return get_permissions(S_IRGRP, S_IWGRP, S_IXGRP)

func set_others_permissions(flags) -> void:
	others_permissions = flags
	set_permissions(flags, S_IROTH, S_IWOTH, S_IXOTH)

func get_others_permissions() -> int:
	return get_permissions(S_IROTH, S_IWOTH, S_IXOTH)

func set_permissions(flags, read_bit, write_bit, execute_bit) -> void:
	user_permissions = flags
	if flags & READ:
		_attributes |= read_bit
	else:
		_attributes &= ~read_bit
	if flags & WRITE:
		_attributes |= write_bit
	else:
		_attributes &= ~write_bit
	if flags & EXECUTE:
		_attributes |= execute_bit
	else:
		_attributes &= ~execute_bit

func get_permissions(read_bit, write_bit, execute_bit) -> int:
	var flags = 0
	flags |= READ if _attributes & read_bit else 0
	flags |= WRITE if _attributes & write_bit else 0
	flags |= EXECUTE if _attributes & execute_bit else 0
	return flags


func set_file_type(type):
	_attributes &= ~S_IFMT
	_attributes |= type

func get_file_type() -> int:
	return _attributes & S_IFMT


func get_path_name() -> String:
	if dir_name == "/":
		return "/%s" % file_name
	else:
		return "%s/%s" % [dir_name, file_name]


func is_class(type: String):
	return type == get_class() or .is_class(type)


func get_class() -> String:
	return "PosixFile"


func _ready():
	if not dir_name:
		var parent_file = _get_parent_file_or_null()
		if parent_file:
			dir_name = parent_file.path_name
		else:
			dir_name = "/"


func _get_parent_file_or_null(node: Node = self):
	var parent = node.get_node_or_null("..")
	var grandparent = node.get_node_or_null("../..")
	
	if not parent or not grandparent:
		return null
	elif parent and grandparent:
		for child in grandparent.get_children():
			if child != parent && child.is_class(get_class()):
				return child
	
	return _get_parent_file_or_null(parent)
#
#	if not parent or not grandparent:
#		return null
#	else:
#		return null
#		for child in grandparent.get_children():
#			if child != parent and child.is_class(get_class()):
#				return child
	
	#return _get_parent_file_or_null(grandparent)


func get_children_files(node: Node = self, children := []) -> Array:
	for child in node.get_children():
		if child.is_class(get_class()):
			children.append(child)
		else:
			get_children_files(child, children)
	return children
