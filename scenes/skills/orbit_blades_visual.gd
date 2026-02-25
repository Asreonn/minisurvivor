extends Node2D

const COLOR := Color(0.0, 1.0, 0.8)
var skill: Node  # orbit_blades skill reference


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if not skill:
		return

	var blade_count: int = skill.blade_count
	var orbit_radius: float = skill.orbit_radius
	var angle: float = skill.angle
	var blade_size: float = skill.blade_size

	for i in blade_count:
		var blade_angle := angle + TAU * i / blade_count
		var pos := Vector2(cos(blade_angle), sin(blade_angle)) * orbit_radius

		# Draw triangle blade
		GeoDraw.draw_regular_polygon(self, pos, blade_size, 3, COLOR, blade_angle)

		# Glow
		draw_circle(pos, blade_size + 2, Color(COLOR, 0.2))
