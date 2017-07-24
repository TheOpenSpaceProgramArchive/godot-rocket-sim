extends RigidBody2D

# Initial speed.
var current_speed = Vector2(0.0, 0.0)

# Ball's acceleration.
var acceleration = 1.5

# Ball's speed.
var player_speed = 200

func move(speed, acc, delta):
	current_speed.x = lerp(current_speed.x, speed, acc * delta)
	set_linear_velocity(Vector2(current_speed.x, get_linear_velocity().y))

func fly(speed, acc, delta):
	current_speed.y = lerp(current_speed.y, speed, acc * delta)
	set_linear_velocity(Vector2(get_linear_velocity().x, current_speed.y))
	
func _ready():
	# Viewport width.
	var width = get_viewport().get_rect().size.width # px
	# Called every time the node is added to the scene.
	set_pos(Vector2(width / 2, 300))
	
	set_process(true)

func _process(delta):
	if (Input.is_key_pressed(KEY_W)):
		fly(-player_speed, acceleration, delta)
		get_node("Exhaust").set_hidden(false)
		print(get_linear_velocity())
	else:
		get_node("Exhaust").set_hidden(true)
	if (Input.is_key_pressed(KEY_A)):
		move(-player_speed, acceleration, delta)
		print(get_linear_velocity())
	if (Input.is_key_pressed(KEY_D)):
		move(player_speed, acceleration, delta)
		print(get_linear_velocity())
