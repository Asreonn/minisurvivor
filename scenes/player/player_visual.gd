extends Node2D

const BODY_RADIUS := 16.0
const RING_RADIUS := 18.0
const BODY_COLOR := Color(0.0, 0.9, 1.0)  # cyan
const RING_COLOR := Color.WHITE

var breath_phase := 0.0
var ghost_trail: Array[Dictionary] = []
const MAX_GHOSTS := 5
const GHOST_INTERVAL := 0.03
var ghost_timer := 0.0

@onready var player: CharacterBody2D = get_parent()


func _process(delta: float) -> void:
	breath_phase += delta * 3.0

	# Ghost trail when moving
	if player.velocity.length() > 30.0:
		ghost_timer += delta
		if ghost_timer >= GHOST_INTERVAL:
			ghost_timer = 0.0
			ghost_trail.append({
				"pos": global_position,
				"alpha": 0.4,
			})
			if ghost_trail.size() > MAX_GHOSTS:
				ghost_trail.pop_front()

	# Fade ghosts
	var i := ghost_trail.size() - 1
	while i >= 0:
		ghost_trail[i]["alpha"] -= delta * 2.0
		if ghost_trail[i]["alpha"] <= 0.0:
			ghost_trail.remove_at(i)
		i -= 1

	queue_redraw()


func _draw() -> void:
	# Ghost trail
	for ghost in ghost_trail:
		var local_pos: Vector2 = ghost["pos"] - global_position
		var c := Color(BODY_COLOR, ghost["alpha"])
		draw_circle(local_pos, BODY_RADIUS * 0.8, c)

	# Breathing scale
	var breath_scale := 1.0 + sin(breath_phase) * 0.03

	# Outer ring
	GeoDraw.draw_regular_polygon(self, Vector2.ZERO, RING_RADIUS * breath_scale, 32, RING_COLOR, 0.0, 1.5)

	# Inner body
	draw_circle(Vector2.ZERO, BODY_RADIUS * breath_scale, BODY_COLOR)

	# Direction triangle
	if player:
		var dir: Vector2 = player.facing_dir
		var tip := dir * (RING_RADIUS + 6.0) * breath_scale
		var perp := dir.rotated(PI * 0.5) * 4.0
		var base_offset := dir * RING_RADIUS * breath_scale
		var tri := PackedVector2Array([tip, base_offset + perp, base_offset - perp])
		draw_colored_polygon(tri, Color.WHITE)
