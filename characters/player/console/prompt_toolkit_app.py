import sys
import contextvars
import asyncio
from threading import Thread
from prompt_toolkit.data_structures import Size
from prompt_toolkit.input import create_pipe_input
from prompt_toolkit.output.vt100 import Vt100_Output
from prompt_toolkit.application.current import create_app_session
from godot import exposed, export
from godot import *


class Stdout:
	def __init__(self, writefunc, encoding: str = "utf8") -> None:
		self._writefunc = writefunc
		self._encoding = encoding
		self._errors = "strict"
		self._buffer: List[bytes] = []
	
	def write(self, data: str) -> None:
		data = data.replace("\n", "\r\n")
		data = data.encode(self._encoding, errors=self._errors)
		self._buffer.append(data)
		self.flush()
	
	def flush(self):
		self._writefunc(PoolByteArray(b"".join(self._buffer)))
		self._buffer = []
	
	def isatty(self) -> bool:
		return True
	
	@property
	def encoding(self) -> str:
		return self._encoding
	
	@property
	def errors(self) -> str:
		return self._errors


@exposed
class PromptToolkitApp(Node):
	
	terminal_path = export(NodePath)
	redirect_stdout = export(bool, default=True)
	redirect_stderr = export(bool, default=False)
	focused = export(bool, default=True)
	app = None
	
	def _enter_tree(self):
		self.input = create_pipe_input()
	
	def _ready(self):
		self.terminal = self.get_node(self.terminal_path)
		self.terminal.connect("data_sent", self, "_on_Terminal_data_sent")
		self.terminal.connect("size_changed", self, "_on_Terminal_size_changed")
		if self.focused:
			self.terminal.grab_focus()
		
		self.stdout = Stdout(writefunc=self.terminal.write)
		self.output = Vt100_Output(stdout=self.stdout,
				get_size=self._get_terminal_size, write_binary=False)
		
		self.thread = Thread(target=self._main_wrapped)
		self.thread.start()
	
	def _main_wrapped(self):
		asyncio.set_event_loop(asyncio.new_event_loop())
		with create_app_session(input=self.input, output=self.output):
			# Wait until here to redirect stdout and/or stderr otherwise errors
			# and output from the previous code would be written to the Terminal
			# node rather than editor Output.
			if self.redirect_stdout:
				sys.stdout = self.stdout
			if self.redirect_stderr:
				sys.stderr = self.stdout
			self.main()
	
	def main(self):
		raise NotImplementedError
	
	def _get_terminal_size(self) -> Size:
		return Size(self.terminal.rows, self.terminal.cols)
	
	def _on_Terminal_data_sent(self, data: PoolByteArray) -> None:
		self.input.send_bytes(bytes(data))
	
	def _on_Terminal_size_changed(self, _new_size: Vector2):
		try:
			self.app._on_resize()
		except AttributeError:
			pass
	
	def _exit_tree(self):
		self.input.send_bytes(b'\x04') # Sends EOF to input (i.e. typing ctrl+D)
		try:
			self.app.exit()
		except AttributeError:
			pass
		self.thread.join()
