extends Node2D

var flash_ref: Node


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if not flash_ref or not flash_ref.active:
		return

	var t: float = flash_ref.flash_timer / flash_ref.flash_duration
	var alpha := (1.0 - t) * 0.5
	var color: Color = flash_ref.flash_color
	color.a = alpha
	var vp_size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, vp_size), color)
