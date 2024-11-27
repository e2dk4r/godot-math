@tool
extends Node2D

@export var player : Player
@export var explosive : Explosive	

func _process(_dt: float) -> void:
	#if Engine.is_editor_hint():
	queue_redraw()

func _draw() -> void:
	#if not Engine.is_editor_hint():
	#	return
	var origin: Vector2 = Vector2(0, 0)
	draw_line(origin, explosive.position, Color.RED, 1)
	draw_line(origin, player.position, Color.BLUE, 1)
	
	var explosiveNormalizedPosition = explosive.position.normalized()
	var scalerProjection = explosiveNormalizedPosition.dot(player.position)
	var vectorProjection = explosiveNormalizedPosition * scalerProjection
	draw_line(origin, vectorProjection, Color.AQUA, 1)
	draw_circle(explosiveNormalizedPosition, 0.1, Color.BEIGE)
	
	# show explosive trigger circle
	draw_circle(explosive.position, explosive.radius * Global.PIXELS_PER_METER, Color.DARK_SLATE_BLUE, false, 1)
	
	var diff: Vector2 = player.position - explosive.position
	draw_line(explosive.position, explosive.position + diff, Color.ORANGE)
	var diffInMeters: float = sqrt(diff.x ** 2 + diff.y ** 2) * Global.METERS_PER_PIXEL
	var isExplosiveWillExplode = diffInMeters < explosive.radius
		
	$Label.text = \
		"diff @(%.2f, %.2f)" % [diff.x, diff.y ] \
		+ " %.2f px %.2f m" % [diff.length(), diffInMeters] \
		+ "\n" + "  explosive @(%.2f, %.2f)" % [explosive.position.x, explosive.position.y ] \
		+ "\n" + "  player    @(%.2f, %.2f)" % [player.position.x, player.position.y ] \
		+ "\n" + "explodes %s" % ("yes" if isExplosiveWillExplode else "no")
