class_name LevelUpRing
extends Node2D

var ring_radius := 0.0
var max_radius := 200.0
var expand_speed := 600.0
var timer := 0.0
var duration := 0.4


func setup(pos: Vector2) -> void:
	global_position = pos


func _process(delta: float) -> void:
	timer += delta
	ring_radius += expand_speed * delta

	if timer >= duration:
		queue_free()
		return

	queue_redraw()


func _draw() -> void:
	var t := timer / duration
	var alpha := (1.0 - t)
	var width := 3.0 * (1.0 - t) + 1.0

	draw_arc(Vector2.ZERO, ring_radius, 0, TAU, 48, Color(1, 1, 1, alpha), width)
	draw_arc(Vector2.ZERO, ring_radius * 0.8, 0, TAU, 48, Color(1, 1, 0.8, alpha * 0.5), width * 0.5)
