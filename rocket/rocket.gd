extends RigidBody2D

# Initial speed.
var current_speed = Vector2(0.0, 0.0)

# Ball's acceleration.
var acceleration = 1.5

# Ball's speed.
var player_speed = 200

# The rocket's yaw control rotational period imparted by an internal gyrosope.
var period = 2.0 # s

func yaw(delta):
	set_rot(2 * PI * delta / period + get_rot())

func fly(speed, acc, delta):
	current_speed.y = lerp(current_speed.y, speed, acc * delta)
	set_linear_velocity(Vector2(get_linear_velocity().x, current_speed.y))

func _ready():
	# Viewport width.
	var width = get_viewport().get_rect().size.width # px
	# Called every time the node is added to the scene.
	set_pos(Vector2(width / 2, 300))

	set_fixed_process(true)

func _fixed_process(delta):
	if (Input.is_key_pressed(KEY_W)):
		fly(-player_speed, acceleration, delta)
		get_node("Exhaust").set_hidden(false)
		print(get_linear_velocity())
	else:
		get_node("Exhaust").set_hidden(true)
	if (Input.is_key_pressed(KEY_A)):
		yaw(delta)
		print(get_rot())
	if (Input.is_key_pressed(KEY_D)):
		yaw(-delta)
		print(get_rot())
