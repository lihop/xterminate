import sys
from threading import Thread
from prompt_toolkit import prompt, PromptSession, ANSI, HTML, print_formatted_text
from godot import exposed, export
from godot import *
from .prompt_toolkit_app import PromptToolkitApp


@exposed
class console_app(PromptToolkitApp):
	"""
	This is the main console application which the player uses to take in-game
	actions. Pretty much all of the gameplay is command line driven.
	"""
	
	def main(self):
		# Very important that we specify input and output, otherwise the
		# terminal will mostly work, but not control characters (e.g. backspace,
		# new line, etc),or ANSI escape sequences will be sent.
		session = PromptSession(input=self.input, output=self.output)
		print = print_formatted_text

		while True:
			try:
				text = session.prompt(HTML('<palegreen>> </palegreen>'))
			except KeyboardInterrupt:
				continue
			except EOFError:
				continue
			else:
				print('You entered:', text)
				print('looking for file to execute...')
				bin_path = str(ProjectSettings.globalize_path("res://system/bin/")) + "rm" + ".py"
				print('happy?')
				print(bin_path)
