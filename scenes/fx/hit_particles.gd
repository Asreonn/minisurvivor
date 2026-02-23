class_name HitParticles
extends Node2D

var particles: Array[Dictionary] = []
var lifetime := 0.3
var timer := 0.0


func setup(pos: Vector2, color: Color, count: int = 6) -> void:
	global_position = pos
	for i in count:
		var angle := randf() * TAU
		var speed := randf_range(80.0, 200.0)
		particles.append({
			"pos": Vector2.ZERO,
			"vel": Vector2(cos(angle), sin(angle)) * speed,
			"color": color,
			"size": randf_range(2.0, 4.0),
		})


func _process(delta: float) -> void:
	timer += delta
	if timer >= lifetime:
		queue_free()
		return

	var t := timer / lifetime
	for p in particles:
		p["pos"] += p["vel"] * delta
		p["vel"] *= 0.95

	queue_redraw()


func _draw() -> void:
	var alpha := 1.0 - timer / lifetime
	for p in particles:
		var c: Color = p["color"]
		c.a = alpha
		draw_circle(p["pos"], p["size"], c)
