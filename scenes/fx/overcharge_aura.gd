extends Node2D

const COLOR := Color(1.0, 0.6, 0.0)
var pulse_phase := 0.0
var particles: Array[Dictionary] = []
const PARTICLE_COUNT := 8
var active := false


func _ready() -> void:
	Events.overcharge_started.connect(_on_overcharge_start)
	Events.overcharge_ended.connect(_on_overcharge_end)


func _on_overcharge_start() -> void:
	active = true
	_init_particles()


func _on_overcharge_end() -> void:
	active = false
	particles.clear()


func _init_particles() -> void:
	particles.clear()
	for i in PARTICLE_COUNT:
		particles.append({
			"angle": randf() * TAU,
			"dist": randf_range(40.0, 80.0),
			"speed": randf_range(2.0, 4.0),
			"size": randf_range(2.0, 4.0),
		})


func _process(delta: float) -> void:
	if not active:
		queue_redraw()
		return

	pulse_phase += delta * 6.0

	for p in particles:
		p["dist"] -= p["speed"] * delta * 60.0
		if p["dist"] < 10.0:
			p["dist"] = randf_range(50.0, 80.0)
			p["angle"] = randf() * TAU

	queue_redraw()


func _draw() -> void:
	if not active:
		return

	# Pulsing ring
	var pulse := 1.0 + sin(pulse_phase) * 0.1
	var ring_r := 30.0 * pulse
	draw_arc(Vector2.ZERO, ring_r, 0, TAU, 32, Color(COLOR, 0.4), 2.0)
	draw_arc(Vector2.ZERO, ring_r + 4, 0, TAU, 32, Color(COLOR, 0.15), 4.0)

	# Particles moving inward
	for p in particles:
		var a: float = p["angle"]
		var d: float = p["dist"]
		var s: float = p["size"]
		var pos := Vector2(cos(a), sin(a)) * d
		var alpha: float = d / 80.0
		draw_circle(pos, s, Color(COLOR, alpha * 0.6))
