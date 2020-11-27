from godot import exposed, export
from godot import *
from olipy.mosaic import MirroredMosaicGibberish
from textwrap import fill


class LargeArtwork(MirroredMosaicGibberish):
	def generate(self, width, height):
		m = self.tweet()
		rows = m.split("\n")
		rows[:] = [row.center(width) for row in rows]
		if len(rows) < height:
			for i in range((height - len(rows)) // 2):
				rows.insert(0, "")
		return "\r\n".join(rows)


@exposed
class artwork(Spatial):
	
	
	def _ready(self):
		self.terminal = self.get_node("Viewport/Terminal")
		self.generate_artwork()
	
	
	def generate_artwork(self, *kwargs):
		self.terminal.write("\u001bc")
		mosaic = LargeArtwork()
		mosaic.width = 12
		self.terminal.write(mosaic.generate(self.terminal.cols, self.terminal.rows))
		self.terminal.write("\u001b[?25l")
