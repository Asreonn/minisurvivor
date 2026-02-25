class_name TrailEffect
extends Node2D

var points: Array[Vector2] = []
var max_points := 5
var color := Color.WHITE
var width := 3.0
var fade_speed := 4.0


func _process(delta: float) -> void:
	if get_parent():
		points.push_front(global_position)
	if points.size() > max_points:
		points.pop_back()
	queue_redraw()


func _draw() -> void:
	if points.size() < 2:
		return

	for i in points.size() - 1:
		var t := float(i) / points.size()
		var c := Color(color, (1.0 - t) * 0.6)
		var w := width * (1.0 - t)
		var p1: Vector2 = points[i] - global_position
		var p2: Vector2 = points[i + 1] - global_position
		draw_line(p1, p2, c, w)
