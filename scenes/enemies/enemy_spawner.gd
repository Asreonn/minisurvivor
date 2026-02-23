extends Node

const SPAWN_RING_RADIUS := 600.0
const MAX_ENEMIES := 200

var spawn_timer := 0.0
var current_phase: Dictionary = {}
var scene_cache: Dictionary = {}


func _process(delta: float) -> void:
	if not GameManager.is_running:
		return

	var phase: Dictionary = WaveData.get_current_phase(GameManager.elapsed_time)
	if phase != current_phase:
		current_phase = phase
		Events.wave_changed.emit(WaveData.PHASES.find(phase))

	var interval: float = current_phase.get("spawn_interval", 1.0)
	spawn_timer += delta
	if spawn_timer >= interval:
		spawn_timer = 0.0
		_try_spawn()


func _try_spawn() -> void:
	var current_count := get_tree().get_nodes_in_group("enemies").size()
	if current_count >= MAX_ENEMIES:
		return

	if not GameManager.player:
		return

	var scene_path: String = WaveData.pick_enemy_scene(current_phase)
	var scene: PackedScene = _get_scene(scene_path)
	if not scene:
		return

	var spawn_pos := MathUtils.random_point_on_circle(
		GameManager.player.global_position, SPAWN_RING_RADIUS
	)

	# Clamp to arena bounds
	spawn_pos.x = clampf(spawn_pos.x, -950, 950)
	spawn_pos.y = clampf(spawn_pos.y, -950, 950)

	var enemy := scene.instantiate()
	enemy.global_position = spawn_pos
	get_tree().current_scene.add_child(enemy)
	Events.enemy_spawned.emit(enemy)


func _get_scene(path: String) -> PackedScene:
	if path in scene_cache:
		return scene_cache[path]
	var scene: PackedScene = load(path)
	if scene:
		scene_cache[path] = scene
	return scene
