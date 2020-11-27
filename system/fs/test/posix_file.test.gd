extends "res://addons/gut/test.gd"


class Test:
	extends "res://addons/gut/test.gd"


	var TestScene := load("res://system/fs/test/posix_file.test.tscn")
	var test_scene = TestScene.instance()


	func before_each():
		test_scene.free()
		test_scene = TestScene.instance()
		add_child(test_scene)


	func test_root_pathname():
		assert_eq("/", test_scene.get_node("PosixFile").path_name)


	func test_top_level_directory_path_name():
		assert_eq("/Directory1", test_scene.get_node("Directory1/PosixFile").path_name)


	func test_top_level_file_path_name():
		assert_eq("/File1", test_scene.get_node("File1/PosixFile").path_name)


	func test_nested_directory_path_name():
		assert_eq("/Directory1/Directory1_1", test_scene.get_node("Directory1/Directory1_1/PosixFile").path_name)


	func test_nested_file_path_name():
		assert_eq("/Directory1/File1_1", test_scene.get_node("Directory1/File1_1/PosixFile").path_name)


	func test_doubly_nested_file_path_name():
		assert_eq("/Directory1/Directory1_1/File1_1_1", test_scene.get_node("Directory1/Directory1_1/File1_1_1/PosixFile").path_name)


	func test_arbitrarily_nested_top_level_directory_path_name():
		assert_eq("/Directory2", test_scene.get_node("Spatial/Spatial/Spatial/Directory2/PosixFile").path_name)


	func test_arbitrarily_nested_file_path_name():
		assert_eq("/Directory2/File2_1", test_scene.get_node("Spatial/Spatial/Spatial/Directory2/Spatial/Spatial/Spatial/File2_1/PosixFile").path_name)


	func test_absolute_directory_path_name():
		assert_eq("/some/other/path/AbsoluteDirectory1", test_scene.get_node("AbsoluteDirectory1/PosixFile").path_name)


	func test_absolute_file_path_name():
		assert_eq("/some/other/path/AbsoluteDirectory1/AbsoluteFile1", test_scene.get_node("AbsoluteDirectory1/AbsoluteFile1/PosixFile").path_name)


	func test_absolute_arbitrarily_nested_file_path_name():
		assert_eq("/some/other/path/AbsoluteDirectory1/AbsoluteFile2", test_scene.get_node("AbsoluteDirectory1/Spatial/Spatial/Spatial/AbsoluteFile2/PosixFile").path_name)


	func after_all():
		test_scene.free()


class TestAbsoluteTopLevel:
	extends "res://addons/gut/test.gd"


	var TestScene := load("res://system/fs/test/top_level_absolute_directory.test.tscn")
	var test_scene = TestScene.instance()


	func before_each():
		test_scene.free()
		test_scene = TestScene.instance()
		add_child(test_scene)
	
	
	func test_top_level_directory_path():
		assert_eq("/some/other/path", test_scene.get_node("PosixFile").path_name)
	
	
	func test_file_path_name():
		assert_eq("/some/other/path/File1", test_scene.get_node("File1/PosixFile").path_name)
	
	
	func test_nested_file_path_name():
		assert_eq("/some/other/path/File2", test_scene.get_node("Spatial/Spatial/Spatial/File2/PosixFile").path_name)
	
	
	func test_another_nested_file_path_name():
		assert_eq("/some/other/path/Directory1/File1_1", test_scene.get_node("Spatial2/Spatial/Directory1/Spatial/File1_1/PosixFile").path_name)
	
	
	func after_all():
		test_scene.free()
