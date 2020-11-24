import argparse
from godot import exposed, export
from godot import *


@exposed
class rm(Node):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		pass
	
	
	def run(self, args := []):
		parser = argparse.ArgumentParser()
		parser.add_argument("echo", help="echo the string you use here")
		args = parser.parse_args(args)
		print(args.echo)
