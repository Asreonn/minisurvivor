extends Node2D

var beam_dir := Vector2.RIGHT
var beam_length := 300.0
var beam_width := 8.0
var beam_color := Color(0.8, 0.2, 1.0)
var timer := 0.0
const DURATION := 0.2


func _process(delta: float) -> void:
	timer += delta
	if timer >= DURATION:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var alpha := 1.0 - timer / DURATION
	var end := beam_dir * beam_length

	# Glow (wider, transparent)
	var glow_w := beam_width * 2.5
	var perp := beam_dir.rotated(PI / 2) * glow_w / 2
	var glow_pts := PackedVector2Array([
		-perp, end - perp, end + perp, perp
	])
	draw_colored_polygon(glow_pts, Color(beam_color, alpha * 0.2))

	# Core beam
	var core_w := beam_width
	var core_perp := beam_dir.rotated(PI / 2) * core_w / 2
	var core_pts := PackedVector2Array([
		-core_perp, end - core_perp, end + core_perp, core_perp
	])
	draw_colored_polygon(core_pts, Color(beam_color, alpha * 0.8))

	# Bright center line
	draw_line(Vector2.ZERO, end, Color(1, 1, 1, alpha), 2.0)
