extends Node2D

const BAR_HEIGHT := 8.0
const BAR_Y := 40.0
const MARGIN := 20.0
const TIMER_COLOR := Color.WHITE
const XP_BAR_BG := Color(0.15, 0.15, 0.15)
const XP_BAR_FILL := Color(0.2, 1.0, 0.3)
const HP_BAR_BG := Color(0.15, 0.15, 0.15)
const HP_BAR_FILL := Color(1.0, 0.2, 0.2)
const GRAZE_COLOR := Color(1.0, 0.6, 0.0)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var vp_size := get_viewport_rect().size

	# Timer (top center)
	var elapsed := GameManager.elapsed_time
	var minutes := int(elapsed) / 60
	var seconds := int(elapsed) % 60
	var timer_text := "%d:%02d" % [minutes, seconds]
	draw_string(ThemeDB.fallback_font, Vector2(vp_size.x / 2 - 24, 30), timer_text, HORIZONTAL_ALIGNMENT_CENTER, -1, 24, TIMER_COLOR)

	# XP bar (top, full width)
	var bar_width := vp_size.x - MARGIN * 2
	var xp_ratio := 0.0
	if GameManager.xp_to_next_level > 0:
		xp_ratio = float(GameManager.current_xp) / GameManager.xp_to_next_level

	draw_rect(Rect2(MARGIN, BAR_Y, bar_width, BAR_HEIGHT), XP_BAR_BG)
	draw_rect(Rect2(MARGIN, BAR_Y, bar_width * xp_ratio, BAR_HEIGHT), XP_BAR_FILL)

	# Level text
	var level_text := "Lv.%d" % GameManager.player_level
	draw_string(ThemeDB.fallback_font, Vector2(MARGIN, BAR_Y + BAR_HEIGHT + 16), level_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)

	# HP bar (below XP)
	if GameManager.player:
		var hp_y := BAR_Y + BAR_HEIGHT + 24
		var hp_ratio: float = GameManager.player.hp / GameManager.player.max_hp
		draw_rect(Rect2(MARGIN, hp_y, bar_width * 0.3, 6), HP_BAR_BG)
		draw_rect(Rect2(MARGIN, hp_y, bar_width * 0.3 * hp_ratio, 6), HP_BAR_FILL)

	# Graze counter (top right)
	var graze_text := "GRAZE: %d" % GameManager.graze_count
	var graze_color := GRAZE_COLOR if GameManager.overcharge_active else Color(0.7, 0.7, 0.7)
	draw_string(ThemeDB.fallback_font, Vector2(vp_size.x - 140, 30), graze_text, HORIZONTAL_ALIGNMENT_RIGHT, -1, 16, graze_color)

	if GameManager.overcharge_active:
		draw_string(ThemeDB.fallback_font, Vector2(vp_size.x / 2 - 60, 70), "OVERCHARGE!", HORIZONTAL_ALIGNMENT_CENTER, -1, 20, GRAZE_COLOR)

	# Skill icons (bottom left)
	var icon_y := vp_size.y - 60
	var icon_x := MARGIN
	for skill_id in GameManager.active_skills:
		var lvl: int = GameManager.active_skills[skill_id]
		_draw_skill_icon(Vector2(icon_x, icon_y), skill_id, lvl)
		icon_x += 40


func _draw_skill_icon(pos: Vector2, skill_id: String, level: int) -> void:
	var color := _skill_color(skill_id)

	# Background circle
	draw_circle(pos, 16, Color(0.1, 0.1, 0.1, 0.8))
	draw_arc(pos, 16, 0, TAU, 32, color, 1.5)

	# Skill initial
	var initial := skill_id.substr(0, 1).to_upper()
	draw_string(ThemeDB.fallback_font, pos + Vector2(-5, 5), initial, HORIZONTAL_ALIGNMENT_CENTER, -1, 14, color)

	# Level dots
	for i in level:
		draw_circle(pos + Vector2(-8 + i * 4, 20), 2.0, color)


func _skill_color(skill_id: String) -> Color:
	match skill_id:
		"aura_ring": return Color(0.3, 0.6, 1.0)
		"orbit_blades": return Color(0.0, 1.0, 0.8)
		"edge_blades": return Color(1.0, 1.0, 0.3)
		"burst_shot": return Color(1.0, 0.4, 0.4)
		"front_cone": return Color(1.0, 0.7, 0.2)
		"line_beam": return Color(0.8, 0.2, 1.0)
		_: return Color.WHITE
