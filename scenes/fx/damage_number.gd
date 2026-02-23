class_name DamageNumber
extends Node2D

var amount := 0.0
var lifetime := 0.6
var timer := 0.0
var float_speed := 60.0
var is_big := false


func setup(dmg: float, pos: Vector2, big: bool = false) -> void:
	amount = dmg
	global_position = pos + Vector2(randf_range(-10, 10), -10)
	is_big = big


func _process(delta: float) -> void:
	timer += delta
	if timer >= lifetime:
		queue_free()
		return

	position.y -= float_speed * delta
	float_speed *= 0.97
	queue_redraw()


func _draw() -> void:
	var t := timer / lifetime
	var alpha := 1.0 - MathUtils.ease_out_cubic(t)
	var font_size := 16 if not is_big else 24
	var color := Color.YELLOW if is_big else Color.WHITE
	color.a = alpha

	var text := str(int(amount))
	draw_string(ThemeDB.fallback_font, Vector2(-float(text.length()) * 4, 0), text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, color)
