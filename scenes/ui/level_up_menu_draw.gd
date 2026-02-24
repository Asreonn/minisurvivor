extends Node2D

const CARD_WIDTH := 280.0
const CARD_HEIGHT := 160.0
const CARD_GAP := 20.0
const BG_COLOR := Color(0, 0, 0, 0.7)
const CARD_BG := Color(0.12, 0.12, 0.18, 0.95)
const CARD_BORDER := Color(0.4, 0.4, 0.6)

const SKILL_NAMES := {
	"aura_ring": "Aura Ring",
	"orbit_blades": "Orbit Blades",
	"edge_blades": "Edge Blades",
	"burst_shot": "Burst Shot",
	"front_cone": "Front Cone",
	"line_beam": "Line Beam",
}

const SKILL_DESCS := {
	"aura_ring": "Damages nearby enemies",
	"orbit_blades": "Blades orbit around you",
	"edge_blades": "Blades bounce off walls",
	"burst_shot": "Radial bullet burst",
	"front_cone": "Cone of bullets forward",
	"line_beam": "Piercing beam attack",
}

const SKILL_COLORS := {
	"aura_ring": Color(0.3, 0.6, 1.0),
	"orbit_blades": Color(0.0, 1.0, 0.8),
	"edge_blades": Color(1.0, 1.0, 0.3),
	"burst_shot": Color(1.0, 0.4, 0.4),
	"front_cone": Color(1.0, 0.7, 0.2),
	"line_beam": Color(0.8, 0.2, 1.0),
}


func _process(_delta: float) -> void:
	if get_parent().active:
		queue_redraw()


func _draw() -> void:
	var menu: Node = get_parent()
	if not menu.active:
		return

	var vp_size := get_viewport_rect().size
	var choices: Array = menu.choices

	# Dim background
	draw_rect(Rect2(Vector2.ZERO, vp_size), BG_COLOR)

	# Title
	draw_string(ThemeDB.fallback_font, Vector2(vp_size.x / 2 - 60, 120), "LEVEL UP!", HORIZONTAL_ALIGNMENT_CENTER, -1, 28, Color.YELLOW)

	# Cards
	var total_height := choices.size() * CARD_HEIGHT + (choices.size() - 1) * CARD_GAP
	var start_y := (vp_size.y - total_height) / 2.0
	var card_x := (vp_size.x - CARD_WIDTH) / 2.0

	for i in choices.size():
		var card_y := start_y + i * (CARD_HEIGHT + CARD_GAP)
		_draw_card(Vector2(card_x, card_y), choices[i])


func _draw_card(pos: Vector2, choice: Dictionary) -> void:
	# Card background
	draw_rect(Rect2(pos, Vector2(CARD_WIDTH, CARD_HEIGHT)), CARD_BG)
	draw_rect(Rect2(pos, Vector2(CARD_WIDTH, CARD_HEIGHT)), CARD_BORDER, false, 2.0)

	var text_x := pos.x + 20
	var text_y := pos.y + 35

	match choice["type"]:
		"new_skill":
			var sid: String = choice["skill_id"]
			var color: Color = SKILL_COLORS.get(sid, Color.WHITE) as Color
			var name_text: String = "NEW: " + str(SKILL_NAMES.get(sid, sid))
			draw_string(ThemeDB.fallback_font, Vector2(text_x, text_y), name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, color)
			draw_string(ThemeDB.fallback_font, Vector2(text_x, text_y + 30), str(SKILL_DESCS.get(sid, "")), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.7, 0.7, 0.7))

		"upgrade":
			var sid: String = choice["skill_id"]
			var color: Color = SKILL_COLORS.get(sid, Color.WHITE) as Color
			var lvl: int = choice["level"]
			var name_text: String = str(SKILL_NAMES.get(sid, sid)) + " Lv." + str(lvl)
			draw_string(ThemeDB.fallback_font, Vector2(text_x, text_y), name_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, color)
			draw_string(ThemeDB.fallback_font, Vector2(text_x, text_y + 30), "Upgrade power & range", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.7, 0.7, 0.7))

		"modifier":
			var mod_id: String = choice["modifier_id"]
			var skill_id_m: String = choice["skill_id"]
			var mod_data: Dictionary = ModifierData.get_modifier(mod_id)
			var mod_name: String = str(mod_data.get("name", mod_id))
			var mod_desc: String = str(mod_data.get("description", ""))
			var mod_color: Color = mod_data.get("color", Color.WHITE) as Color
			var name_text_m: String = mod_name + " -> " + str(SKILL_NAMES.get(skill_id_m, skill_id_m))
			draw_string(ThemeDB.fallback_font, Vector2(text_x, text_y), name_text_m, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, mod_color)
			draw_string(ThemeDB.fallback_font, Vector2(text_x, text_y + 30), mod_desc, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.7, 0.7, 0.7))
