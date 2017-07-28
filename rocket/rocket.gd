extends RigidBody2D

# Path to the root node of the HUD
export(NodePath) var hudPath

# The exhaust animation.
onready var exhaust = get_node("Exhaust")

# Throttle indicator.
onready var throttleIndicator = get_node(hudPath).get_node("throttleIndicator")

# SAS indicator.
onready var sasIndicator = get_node(hudPath).get_node("sasIndicator")

# The torque applied for yaw control.
var yawTorque = 25000

#Engine throttle. (0-1)
var throttle = 0

# SAS helper class
const SAS = preload("res://rocket/sas.gd")

# Instance of SAS helper class
var sas = SAS.new()

# Target orientation for SAS
onready var setpoint = get_rot()

# Whether SAS is enabled
var sasEnabled = false

# Whether the key to toggle SAS was down on the last frame
var sasKeyPressedLastFrame = false

# What output from the PID controller for SAS equals maximum torque
var maxSAS = 0.1

# Ignition force vector.
func force_vector(magnitude):
	return Vector2(0.0, magnitude).rotated(get_rot() + PI)

# Engine ignition.
func ignite(delta):
	exhaust.set_opacity(throttle)
	apply_impulse(exhaust.get_pos().rotated(get_rot()), delta * force_vector(200.0) * throttle)

# Yaw control.
func yaw(delta):
	set_applied_torque(0)
	if Input.is_action_pressed("yawLeft"):
		set_applied_torque(-yawTorque)
	if Input.is_action_pressed("yawRight"):
		set_applied_torque(get_applied_torque() + yawTorque)
	# If there was no player input and SAS is enabled, run the SAS code
	# Otherwise, have SAS target our current orientation
	if get_applied_torque() == 0:
		doSAS(delta)
	else:
		setpoint = get_rot()

# Handles SAS
func doSAS(delta):
	if Input.is_action_pressed("toggleSAS"):
		if not sasKeyPressedLastFrame:
			# Before enabling SAS, set the target orientation to the current orientation
			if !sasEnabled:
				sasEnabled = true
				setpoint = get_rot()
			else:
				sasEnabled = false
			sasIndicator.set_pressed(sasEnabled)
		sasKeyPressedLastFrame = true
	else:
		sasKeyPressedLastFrame = false
	if !sasEnabled:
		return
	# Run the PID controller and clamp its output to within the max torque
	var pidOut = -sas.run(get_rot(), setpoint, delta)
	pidOut = clamp(pidOut, -maxSAS, maxSAS) / maxSAS * yawTorque
	# Apply torque
	set_applied_torque(pidOut)

# Set the throttle based on user input.
func handleThrottleInput(delta):
	if Input.is_action_pressed("throttleUp"):
		throttle += delta / 2
	if Input.is_action_pressed("throttleDown"):
		throttle -= delta / 2
	if Input.is_action_pressed("throttleMax"):
		throttle = 1
	if Input.is_action_pressed("throttleMin"):
		throttle = 0
	throttle = clamp(throttle, 0, 1)
	throttleIndicator.set_value(throttle)

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
	set_fixed_process(true)

func _fixed_process(delta):
	handleThrottleInput(delta)
	ignite(delta)
	yaw(delta)
