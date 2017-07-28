extends Object

# Error value from previous frame
var lastErr = 0

# Sum of past errors
var integral = 0

# Maximum value for integral
var integralMax = 50

# Multipliers for proportional, integral, derivative (respectively)
var kp = 5
var ki = 3.5
var kd = 4

const PI_2 = PI * 2

# Runs the PID controller.
# observed: current value
# setpoint: target value
# delta:    time in seconds since last run
func run(observed, setpoint, delta):
    var err = setpoint - observed
    if err > PI:
        err = PI - err
    if err < -PI:
        err = fmod(PI - err, PI_2)
    integral += err * delta
    integral = clamp(integral, -integralMax, integralMax)
    var derivative = (err - lastErr) / delta
    lastErr = err
    return kp * err + ki * integral + kd * derivative