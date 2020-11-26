import sys
import cmd
import argparse
import threading
import time
from threading import Thread
from prompt_toolkit import prompt, PromptSession, ANSI, HTML, print_formatted_text
from godot import exposed, export
from godot import *
from .ptkcmd import PtkCmd, Completion, complete_files
from .prompt_toolkit_app import PromptToolkitApp


class ConsoleCmd(PtkCmd):
	prompt='MyPtkCmd$ ' #change the prompt
	
	def __init__(self,stdin=None,stdout=None,intro=None,
		interactive=True,do_complete_cmd=True,
		default_shell=False,process_lock=None,
		process_started=None,node=None,**psession_kwargs):

		super().__init__(stdin,stdout,intro,interactive,
		do_complete_cmd,default_shell,**psession_kwargs)
		
		self.process_lock = process_lock
		self.process_started = process_started
		self.node = node
	
	
	__hecho_parser = argparse.ArgumentParser(prog="hecho")
	__hecho_parser.add_argument('--bar', help="bar help")
	__hecho_parser.add_argument('STRING', nargs='*')
	def do_hecho(self, args):
		try:
			parsed = self.__hecho_parser.parse_args(args)
		except SystemExit:
			return
		print("Heck %s" % ' '.join(parsed.STRING))
	
	
	__rm_parser = argparse.ArgumentParser(prog="rm")
	__rm_parser.add_argument('FILE', nargs='*')
	def do_rm(self, args):
		try:
			parsed = self.__rm_parser.parse_args(args)
		except SystemExit:
			return
		
		with self.process_lock:
			self.process_started.wait()
			for file in parsed.FILE:
				n = self.node.get_node_or_null("/root/%s" % file)
				if n:
					n.queue_free()
				else:
					print("rm: cannot remove '%s': No such file or directory" % file)
	
	
	__ls_parser = argparse.ArgumentParser(prog="ls")
	__ls_parser.add_argument("FILE", nargs="?", default=".")
	__ls_parser.add_argument("-a", "--all", action='store_true', help="do not ignore entries start with .")
	__ls_parser.add_argument("-A", "--almost-all", action='store_true', help="do not list implived . and ..")
	__ls_parser.add_argument("-l", action='store_true', help="use long listing format")
	def do_ls(self, args):
		try:
			parsed = self.__ls_parser.parse_args(args)
		except SystemExit:
			return
		
		filename = parsed.FILE
		absolute = filename.startswith('/')
		
		if not absolute:
			with self.process_lock:
				self.process_started.wait()
				current_scene = get_tree().get_current_scene().get_node("File")
	
	
	def do_chmod(self, args):
		print('TODO: Implement chmod')
	
	
	def do_cd(self, args):
		print('TODO: Implement cd')
	
	
	__pwd_parser = argparse.ArgumentParser(prog="pwd", description="print name of current/working directory")
	def do_pwd(self, args):
		try:
			parsed = self.__pwd_parser.parse_args(args)
		except SystemExit:
			return
		
		with self.process_lock:
			self.process_started.wait()
			current_scene = self.node.get_tree().get_current_scene()
			path_name = current_scene.get("path_name")
		print(path_name)


@exposed
class console_app(PromptToolkitApp, cmd.Cmd):
	"""
	This is the main console application which the player uses to take in-game
	actions. Pretty much all of the gameplay is command line driven.
	"""
	
	process_lock = threading.Lock()
	process_started = threading.Event()
	
	
	def main(self):
		# Very important that we specify input and output, otherwise the
		# terminal will mostly work, but not control characters (e.g. backspace,
		# new line, etc),or ANSI escape sequences will be sent.
		#session = PromptSession(input=self.input, output=self.output)
		#print = print_formatted_text
		
		cmd = ConsoleCmd(input=self.input, output=self.output, node=self,
				process_lock=self.process_lock, process_started=self.process_started)
		cmd.cmdloop()

		while True:
			try:
				prompt = str(self.get_node("/root/Player").prompt)
				text = session.prompt(ANSI(prompt))
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
	
	
	def _process(self, _delta):
		if self.process_lock.locked():
			self.process_started.set()
			self.process_lock.acquire()
			self.process_started.clear()
			self.process_lock.release()
