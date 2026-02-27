class_name WaveData
extends RefCounted

# Each phase: {time_start, time_end, enemies: [{scene, weight, interval}], spawn_rate_mult}
# 8-minute (480s) game broken into phases

const PHASES := [
	# Phase 1: 0:00 - 1:00 — Just swarm dots, easy intro
	{
		"time_start": 0,
		"time_end": 60,
		"spawn_interval": 1.0,
		"enemies": [
			{"scene": "res://scenes/enemies/swarm_dot.tscn", "weight": 1.0},
		],
	},
	# Phase 2: 1:00 - 2:00 — More swarm dots, faster
	{
		"time_start": 60,
		"time_end": 120,
		"spawn_interval": 0.7,
		"enemies": [
			{"scene": "res://scenes/enemies/swarm_dot.tscn", "weight": 1.0},
		],
	},
	# Phase 3: 2:00 - 3:00 — Introduce shooters
	{
		"time_start": 120,
		"time_end": 180,
		"spawn_interval": 0.6,
		"enemies": [
			{"scene": "res://scenes/enemies/swarm_dot.tscn", "weight": 0.7},
			{"scene": "res://scenes/enemies/shooter_triangle.tscn", "weight": 0.3},
		],
	},
	# Phase 4: 3:00 - 4:00 — Introduce bombers
	{
		"time_start": 180,
		"time_end": 240,
		"spawn_interval": 0.5,
		"enemies": [
			{"scene": "res://scenes/enemies/swarm_dot.tscn", "weight": 0.5},
			{"scene": "res://scenes/enemies/shooter_triangle.tscn", "weight": 0.3},
			{"scene": "res://scenes/enemies/bomber_square.tscn", "weight": 0.2},
		],
	},
	# Phase 5: 4:00 - 5:00 — Elites appear
	{
		"time_start": 240,
		"time_end": 300,
		"spawn_interval": 0.45,
		"enemies": [
			{"scene": "res://scenes/enemies/swarm_dot.tscn", "weight": 0.4},
			{"scene": "res://scenes/enemies/shooter_triangle.tscn", "weight": 0.25},
			{"scene": "res://scenes/enemies/bomber_square.tscn", "weight": 0.2},
			{"scene": "res://scenes/enemies/elite_polygon.tscn", "weight": 0.15},
		],
	},
	# Phase 6: 5:00 - 6:00 — Ramp up
	{
		"time_start": 300,
		"time_end": 360,
		"spawn_interval": 0.35,
		"enemies": [
			{"scene": "res://scenes/enemies/swarm_dot.tscn", "weight": 0.35},
			{"scene": "res://scenes/enemies/shooter_triangle.tscn", "weight": 0.25},
			{"scene": "res://scenes/enemies/bomber_square.tscn", "weight": 0.2},
			{"scene": "res://scenes/enemies/elite_polygon.tscn", "weight": 0.2},
		],
	},
	# Phase 7: 6:00 - 7:00 — Intense
	{
		"time_start": 360,
		"time_end": 420,
		"spawn_interval": 0.25,
		"enemies": [
			{"scene": "res://scenes/enemies/swarm_dot.tscn", "weight": 0.3},
			{"scene": "res://scenes/enemies/shooter_triangle.tscn", "weight": 0.25},
			{"scene": "res://scenes/enemies/bomber_square.tscn", "weight": 0.2},
			{"scene": "res://scenes/enemies/elite_polygon.tscn", "weight": 0.25},
		],
	},
	# Phase 8: 7:00 - 8:00 — Final frenzy
	{
		"time_start": 420,
		"time_end": 480,
		"spawn_interval": 0.15,
		"enemies": [
			{"scene": "res://scenes/enemies/swarm_dot.tscn", "weight": 0.25},
			{"scene": "res://scenes/enemies/shooter_triangle.tscn", "weight": 0.25},
			{"scene": "res://scenes/enemies/bomber_square.tscn", "weight": 0.25},
			{"scene": "res://scenes/enemies/elite_polygon.tscn", "weight": 0.25},
		],
	},
]


static func get_current_phase(elapsed_time: float) -> Dictionary:
	for phase in PHASES:
		if elapsed_time >= phase["time_start"] and elapsed_time < phase["time_end"]:
			return phase
	# Return last phase if beyond
	return PHASES[PHASES.size() - 1]


static func pick_enemy_scene(phase: Dictionary) -> String:
	var enemies: Array = phase["enemies"]
	var roll := randf()
	var cumulative := 0.0
	for entry in enemies:
		cumulative += entry["weight"]
		if roll <= cumulative:
			return entry["scene"]
	return enemies[enemies.size() - 1]["scene"]
