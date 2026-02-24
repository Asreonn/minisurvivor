extends Node2D

var ring_radius := 80.0
var pulse_phase := 0.0
const COLOR := Color(0.2, 0.5, 1.0, 0.3)
const GLOW_COLOR := Color(0.3, 0.6, 1.0, 0.15)


func set_radius(r: float) -> void:
	ring_radius = r


func _process(delta: float) -> void:
	pulse_phase += delta * 4.0
	queue_redraw()


func _draw() -> void:
	var pulse := 1.0 + sin(pulse_phase) * 0.05
	var r := ring_radius * pulse

	# Outer glow
	draw_arc(Vector2.ZERO, r + 4.0, 0, TAU, 64, GLOW_COLOR, 6.0)

	# Main ring
	draw_arc(Vector2.ZERO, r, 0, TAU, 64, COLOR, 2.0)

	# Inner fill (very subtle)
	draw_circle(Vector2.ZERO, r, Color(0.2, 0.5, 1.0, 0.05))
