from prompt_toolkit import print_formatted_text
from godot import exposed, export
from godot import *


@exposed
class Node(Node):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		print("Hello from python")
		self.get_node("../DirectionalLight").queue_free()
		self.get_node("../DirectionalLight2").queue_free()
		print_formatted_text("Prompt toolkit alive and well!")
