@tool
class_name Laser
extends Node2D

## velocity in m/s
@export var velocity : Vector2 = Vector2(5.0, 0.0)

func _physics_process(dt: float) -> void:
	# velocity
	# f'(t) = ∫f''(t)
	#       = at + v0
	
	# apply drag
	# fdrag(t) = -1/2 CpAv^2
	#    where p is air density,
	#          A is the cross-sectional area,
	#          C is numerical drag coefficient.
	var drag : Vector2 = -0.5 * 0.3 * velocity * dt ** 2
	velocity += drag

	# position
	# f(t) = ∫f'(t)
	#      = 1/2 at² + vt + p0
	var dPosition = (velocity * Global.PIXELS_PER_METER * dt)
	var rayQuery = PhysicsRayQueryParameters2D.create(position, position + dPosition)
	rayQuery.exclude = [self]
	var collision = get_world_2d().direct_space_state.intersect_ray(rayQuery)
	if collision == {}:
		position += dPosition
		return

	# Reflect when collided
	# v' = v - 2(v.n)n
	#   where v' is reflected velocity vector,
	#         v  is velocity vector,
	#         n  is normal of surface collided with.
	var surfaceNormal = collision.normal * Vector2(1, -1)
	velocity -= 2 * velocity.dot(surfaceNormal) * surfaceNormal
