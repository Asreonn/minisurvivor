extends Node2D

var menu_ref: Node


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if not menu_ref or not menu_ref.active:
		return

	var vp_size := get_viewport_rect().size
	var cx := vp_size.x / 2.0

	# Background
	draw_rect(Rect2(Vector2.ZERO, vp_size), Color(0, 0, 0, 0.8))

	# Title
	draw_string(ThemeDB.fallback_font, Vector2(cx - 80, 200), "GAME OVER", HORIZONTAL_ALIGNMENT_CENTER, -1, 32, Color(1.0, 0.3, 0.3))

	# Stats (reveal over time)
	var y := 320.0
	var stats_shown: int = menu_ref.stats_shown

	if stats_shown >= 1:
		var minutes := int(menu_ref.survived_time) / 60
		var seconds := int(menu_ref.survived_time) % 60
		var time_text := "Survived: %d:%02d" % [minutes, seconds]
		draw_string(ThemeDB.fallback_font, Vector2(cx - 80, y), time_text, HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color.WHITE)
		y += 40

	if stats_shown >= 2:
		draw_string(ThemeDB.fallback_font, Vector2(cx - 80, y), "Level: %d" % GameManager.highest_level, HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color.WHITE)
		y += 40

	if stats_shown >= 3:
		draw_string(ThemeDB.fallback_font, Vector2(cx - 80, y), "Enemies: %d" % GameManager.enemies_killed, HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color.WHITE)
		y += 40

	if stats_shown >= 4:
		draw_string(ThemeDB.fallback_font, Vector2(cx - 80, y), "Total Graze: %d" % GameManager.total_graze, HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color.WHITE)
		y += 40

	if stats_shown >= 5:
		# Replay prompt
		var ct: float = menu_ref.count_timer
		var pulse := sin(ct * 4.0) * 0.3 + 0.7
		draw_string(ThemeDB.fallback_font, Vector2(cx - 60, vp_size.y - 200), "TAP TO REPLAY", HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color(1, 1, 1, pulse))
