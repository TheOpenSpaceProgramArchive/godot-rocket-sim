extends RigidBody2D

# The exhaust animation.
onready var exhaust = get_node("Exhaust")

# The torque applied for yaw control.
var yawTorque = 25000

# Ignition force vector.
func force_vector(magnitude):
	return Vector2(0.0, magnitude).rotated(get_rot() + PI)

# Engine ignition.
func ignite(delta):
	if Input.is_key_pressed(KEY_W):
		exhaust.set_hidden(false)
		apply_impulse(exhaust.get_pos().rotated(get_rot()), delta * force_vector(200.0))
	else:
		exhaust.set_hidden(true)

# Yaw control.
func yaw(delta):
	set_applied_torque(0)
	if Input.is_action_pressed("yawLeft"):
		set_applied_torque(-yawTorque)
	if Input.is_action_pressed("yawRight"):
		set_applied_torque(get_applied_torque() + yawTorque)

# Draw the direction of the ingition force.
# func _draw():
# 	var from = exhaust.get_pos()
# 	var to = exhaust.get_pos() - force_vector(200.0)
# 	draw_line(from, to, Color(0, 1, 0))

func _ready():
	# Viewport width.
	var width = get_viewport().get_rect().size.width # px
	# Place the rocket close to the surface.
	set_pos(Vector2(width / 2, 470.0))
	#
	set_fixed_process(true)

func _fixed_process(delta):
	ignite(delta)
	yaw(delta)
