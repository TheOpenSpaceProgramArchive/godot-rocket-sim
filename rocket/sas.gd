extends Object

# Error value from previous frame
var lastErr = 0

# Sum of past errors
var integral = 0

# Maximum value for integral
var integralMax = 50

# Multipliers for proportional, integral, derivative (respectively)
var kp = 1
var ki = 0
var kd = 0

# Runs the PID controller.
# observed: current value
# setpoint: target value
# delta:    time in seconds since last run
func run(observed, setpoint, delta):
    var err = setpoint - observed
    integral += err * delta
    integral = clamp(integral, -integralMax, integralMax)
    var derivative = (err - lastErr) / delta
    lastErr = err
    return kp * err + ki * integral + kd * derivative