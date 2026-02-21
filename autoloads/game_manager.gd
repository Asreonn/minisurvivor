extends Node

const MAX_TIME := 480.0  # 8 minutes

var elapsed_time := 0.0
var is_running := false
var is_paused := false

# Player stats
var player_level := 1
var current_xp := 0
var xp_to_next_level := 10
var total_xp := 0

# Graze
var graze_count := 0
var overcharge_active := false
var overcharge_timer := 0.0
const OVERCHARGE_THRESHOLD := 10
const OVERCHARGE_DURATION := 5.0
const OVERCHARGE_ATTACK_SPEED_MULT := 1.3
const OVERCHARGE_PICKUP_RANGE_MULT := 2.0

# Skills
var active_skills: Dictionary = {}  # skill_id -> level
var active_modifiers: Dictionary = {}  # modifier_id -> skill_id

# Stats for game over
var enemies_killed := 0
var total_graze := 0
var highest_level := 1

var player: CharacterBody2D


func _ready() -> void:
	Events.graze_triggered.connect(_on_graze)
	Events.enemy_killed.connect(_on_enemy_killed)


func _process(delta: float) -> void:
	if not is_running:
		return

	elapsed_time += delta

	if overcharge_active:
		overcharge_timer -= delta
		if overcharge_timer <= 0.0:
			overcharge_active = false
			Events.overcharge_ended.emit()

	if elapsed_time >= MAX_TIME:
		end_game()


func start_game() -> void:
	elapsed_time = 0.0
	player_level = 1
	current_xp = 0
	xp_to_next_level = 10
	total_xp = 0
	graze_count = 0
	overcharge_active = false
	enemies_killed = 0
	total_graze = 0
	highest_level = 1
	active_skills.clear()
	active_modifiers.clear()
	is_running = true
	is_paused = false
	Events.game_started.emit()


func end_game() -> void:
	is_running = false
	Events.game_over.emit(elapsed_time)


func add_xp(amount: int) -> void:
	current_xp += amount
	total_xp += amount
	Events.xp_gained.emit(amount)

	while current_xp >= xp_to_next_level:
		current_xp -= xp_to_next_level
		player_level += 1
		highest_level = max(highest_level, player_level)
		xp_to_next_level = _calc_xp_requirement(player_level)
		Events.level_up.emit(player_level)


func _calc_xp_requirement(level: int) -> int:
	return 10 + (level - 1) * 5


func add_graze() -> void:
	graze_count += 1
	total_graze += 1
	Events.graze_triggered.emit()

	if graze_count >= OVERCHARGE_THRESHOLD and not overcharge_active:
		graze_count = 0
		overcharge_active = true
		overcharge_timer = OVERCHARGE_DURATION
		Events.overcharge_started.emit()


func _on_graze() -> void:
	pass  # Graze is triggered externally via add_graze()


func _on_enemy_killed(_enemy: Node2D, _position: Vector2) -> void:
	enemies_killed += 1


func get_attack_speed_mult() -> float:
	return OVERCHARGE_ATTACK_SPEED_MULT if overcharge_active else 1.0


func get_pickup_range_mult() -> float:
	return OVERCHARGE_PICKUP_RANGE_MULT if overcharge_active else 1.0
