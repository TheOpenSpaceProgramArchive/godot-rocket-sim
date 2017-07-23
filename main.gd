extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Viewport bottom and half of the width.
	set_pos(Vector2(get_viewport().get_rect().size.width / 2, get_viewport().get_rect().size.height)) # px
	# Full width.
	set_scale(Vector2(16.0, 1.0))
