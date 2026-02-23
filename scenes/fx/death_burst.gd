class_name DeathBurst
extends Node2D

var pieces: Array[Dictionary] = []
var lifetime := 0.4
var timer := 0.0


func setup(pos: Vector2, color: Color, radius: float) -> void:
	global_position = pos
	var count := randi_range(4, 6)
	for i in count:
		var angle := TAU * i / count + randf() * 0.3
		var speed := randf_range(100.0, 250.0)
		pieces.append({
			"pos": Vector2.ZERO,
			"vel": Vector2(cos(angle), sin(angle)) * speed,
			"color": color,
			"size": radius * randf_range(0.3, 0.6),
			"rot": randf() * TAU,
			"rot_speed": randf_range(-5.0, 5.0),
			"sides": randi_range(3, 5),
		})


func _process(delta: float) -> void:
	timer += delta
	if timer >= lifetime:
		queue_free()
		return

	for p in pieces:
		p["pos"] += p["vel"] * delta
		p["vel"] *= 0.92
		p["rot"] += p["rot_speed"] * delta

	queue_redraw()


func _draw() -> void:
	var t := timer / lifetime
	var alpha := 1.0 - t
	var scale_factor := 1.0 - t * 0.6

	for p in pieces:
		var c: Color = p["color"]
		c.a = alpha
		var size: float = p["size"] * scale_factor
		GeoDraw.draw_regular_polygon(self, p["pos"], size, p["sides"], c, p["rot"])
