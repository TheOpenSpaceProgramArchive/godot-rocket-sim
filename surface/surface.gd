extends StaticBody2D

# The Earth's surface is a SegmentShape2D.
var surface = SegmentShape2D.new()

func _ready():
	# Viewport width.
	var width = get_viewport().get_rect().size.width # px
	# Viewport height.
	var height = get_viewport().get_rect().size.height # px
	# The Earth's surface will be the viewport width.
	surface.set_a(Vector2(0.0, height))
	surface.set_b(Vector2(width, height))
	# Add the surface.
	add_shape(surface)
