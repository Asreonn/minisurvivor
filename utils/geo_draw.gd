class_name GeoDraw
extends RefCounted

## Draw a regular polygon (N-gon) centered at `center`.
static func draw_regular_polygon(canvas: CanvasItem, center: Vector2, radius: float, sides: int, color: Color, rotation_offset: float = 0.0, width: float = -1.0) -> void:
	var points := PackedVector2Array()
	for i in sides + 1:
		var angle := rotation_offset + TAU * i / sides
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)

	if width > 0.0:
		for i in sides:
			canvas.draw_line(points[i], points[i + 1], color, width)
	else:
		# Filled polygon (drop the closing duplicate)
		points.resize(sides)
		canvas.draw_colored_polygon(points, color)


## Draw a star shape with `points_count` outer points.
static func draw_star(canvas: CanvasItem, center: Vector2, outer_radius: float, inner_radius: float, points_count: int, color: Color, rotation_offset: float = 0.0) -> void:
	var verts := PackedVector2Array()
	var total := points_count * 2
	for i in total:
		var angle := rotation_offset + TAU * i / total
		var r := outer_radius if i % 2 == 0 else inner_radius
		verts.append(center + Vector2(cos(angle), sin(angle)) * r)
	canvas.draw_colored_polygon(verts, color)


## Draw a circle with an additive glow look (layered semi-transparent circles).
static func draw_glow_circle(canvas: CanvasItem, center: Vector2, radius: float, color: Color, layers: int = 3) -> void:
	for i in range(layers, 0, -1):
		var t := float(i) / layers
		var r := radius * (1.0 + t * 0.5)
		var c := Color(color, color.a * (1.0 - t) * 0.5)
		canvas.draw_circle(center, r, c)
	canvas.draw_circle(center, radius, color)


## Draw a polygon with glow (layered outlines fading out).
static func draw_glow_polygon(canvas: CanvasItem, center: Vector2, radius: float, sides: int, color: Color, rotation_offset: float = 0.0, glow_layers: int = 3) -> void:
	for i in range(glow_layers, 0, -1):
		var t := float(i) / glow_layers
		var r := radius + t * 4.0
		var c := Color(color, color.a * (1.0 - t) * 0.4)
		draw_regular_polygon(canvas, center, r, sides, c, rotation_offset, 2.0)
	draw_regular_polygon(canvas, center, radius, sides, color)


## Draw an arc (partial circle outline).
static func draw_arc_line(canvas: CanvasItem, center: Vector2, radius: float, start_angle: float, end_angle: float, color: Color, width: float = 2.0, point_count: int = 32) -> void:
	var points := PackedVector2Array()
	for i in point_count + 1:
		var angle := start_angle + (end_angle - start_angle) * i / point_count
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	for i in point_count:
		canvas.draw_line(points[i], points[i + 1], color, width)
