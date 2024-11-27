class_name Player
extends Node2D

## speed in m/s
@export var speed : float = 10
var speedInMetersPerSecond : float = speed * Global.PIXELS_PER_METER
var runningSpeedInMetersPerSecond : float = speed * 2.8 * Global.PIXELS_PER_METER
## speed limit in m/s
@export var speedLimit : float = 50
var speedLimitSquared : float = speedLimit ** 2

## velocity in m/s
@export var velocity : Vector2 = Vector2(0, 0)

func _physics_process(dt: float) -> void:
	# acceleration
	# f''(t) = a
	var acceleration : Vector2 = Input.get_vector("left", "right", "up", "down")
	if Input.get_action_strength("speed") == 0:
		acceleration *= speedInMetersPerSecond
	else:
		acceleration *= runningSpeedInMetersPerSecond

	# velocity
	# f'(t) = ∫f''(t)
	#       = at + v0
	
	var velocityLengthSquared: float = velocity.x ** 2 + velocity.y ** 2
	#if velocityLengthSquared < speedLimitSquared:
	velocity += acceleration * dt
		
	
	var isAccelerationZero: bool = (acceleration.x == 0 and acceleration.y == 0)
	var isVelocityNotZero: bool = velocityLengthSquared != 0
	if isVelocityNotZero:
		# apply friction
		var deceleration = 3.2 * velocity * dt
		velocity -= deceleration

	# position
	# f(t) = ∫f'(t)
	#      = 1/2 at² + vt + p0
	position += (0.5 * acceleration * dt ** 2 ) + (velocity * dt)
