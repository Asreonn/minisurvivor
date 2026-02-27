extends Node2D

var menu_ref: Node


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if not menu_ref or not menu_ref.active:
		return

	var vp_size := get_viewport_rect().size
	var cx := vp_size.x / 2.0

	# Dark background
	draw_rect(Rect2(Vector2.ZERO, vp_size), Color(0.04, 0.04, 0.1))

	# Floating geometric shapes
	for s in menu_ref.bg_shapes:
		var p: Vector2 = s["pos"]
		var sz: float = s["size"]
		var sides: int = s["sides"]
		var rot: float = s["rot"]
		var alpha: float = s["alpha"]
		GeoDraw.draw_regular_polygon(self, p, sz, sides, Color(1, 1, 1, alpha), rot, 1.0)

	# Title
	var title_y := vp_size.y * 0.3
	draw_string(ThemeDB.fallback_font, Vector2(cx - 120, title_y), "MINISURVIVOR", HORIZONTAL_ALIGNMENT_CENTER, -1, 36, Color(0.0, 0.9, 1.0))

	# Subtitle
	draw_string(ThemeDB.fallback_font, Vector2(cx - 80, title_y + 50), "geometric chaos", HORIZONTAL_ALIGNMENT_CENTER, -1, 18, Color(0.5, 0.5, 0.6))

	# Tap to start (pulsing)
	var time_val: float = menu_ref.timer
	var pulse := sin(time_val * 3.0) * 0.3 + 0.7
	draw_string(ThemeDB.fallback_font, Vector2(cx - 60, vp_size.y * 0.65), "TAP TO START", HORIZONTAL_ALIGNMENT_CENTER, -1, 22, Color(1, 1, 1, pulse))

	# Decorative shapes around title
	var t: float = menu_ref.timer
	for i in 4:
		var angle: float = t * 0.5 + TAU * i / 4.0
		var r := 100.0
		var pos := Vector2(cx + cos(angle) * r, title_y - 20 + sin(angle) * r * 0.3)
		GeoDraw.draw_regular_polygon(self, pos, 8, 3 + i, Color(0, 0.9, 1.0, 0.3), t + i)
