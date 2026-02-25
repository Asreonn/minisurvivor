extends BaseSkill

var damage := 20.0
var beam_length := 300.0
var beam_width := 8.0
var beam_duration := 0.3
var visual: Node2D
const COLOR := Color(0.8, 0.2, 1.0)


func _ready() -> void:
	skill_id = "line_beam"
	cooldown = 2.0
	cooldown_timer = cooldown
	_on_upgrade()


func _on_upgrade() -> void:
	match level:
		1: damage = 20.0; beam_length = 300.0; cooldown = 2.0
		2: damage = 30.0; beam_length = 350.0; cooldown = 1.8
		3: damage = 42.0; beam_length = 400.0; cooldown = 1.6
		4: damage = 55.0; beam_length = 450.0; cooldown = 1.4
		5: damage = 72.0; beam_length = 500.0; cooldown = 1.2; beam_width = 12.0


func activate() -> void:
	if not GameManager.player:
		return

	# Find nearest enemy to aim at
	var player_pos := GameManager.player.global_position
	var target_dir := GameManager.player.facing_dir
	var enemies := get_tree().get_nodes_in_group("enemies")
	var closest_dist := beam_length + 100.0

	for enemy in enemies:
		if enemy is BaseEnemy and not enemy.is_dead:
			var dist := player_pos.distance_to(enemy.global_position)
			if dist < closest_dist:
				closest_dist = dist
				target_dir = (enemy.global_position - player_pos).normalized()

	# Damage all enemies in the beam line
	var hit_count := 0
	for enemy in enemies:
		if enemy is BaseEnemy and not enemy.is_dead:
			if _point_in_beam(enemy.global_position, player_pos, target_dir):
				enemy.take_damage(damage, target_dir)
				hit_count += 1

				# Electric modifier: chain shock
				if has_modifier("electric") and hit_count <= 3:
					_chain_shock(enemy)

	# Visual beam
	_spawn_beam_visual(player_pos, target_dir)


func _point_in_beam(point: Vector2, origin: Vector2, dir: Vector2) -> bool:
	var to_point := point - origin
	var proj := to_point.dot(dir)
	if proj < 0 or proj > beam_length:
		return false
	var perp_dist := abs(to_point.cross(dir))
	return perp_dist <= beam_width


func _chain_shock(source: BaseEnemy) -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy != source and enemy is BaseEnemy and not enemy.is_dead:
			if source.global_position.distance_to(enemy.global_position) < 80.0:
				enemy.take_damage(damage * 0.3, Vector2.ZERO)
				break


func _spawn_beam_visual(origin: Vector2, dir: Vector2) -> void:
	var beam := Node2D.new()
	beam.global_position = origin
	beam.set_script(load("res://scenes/skills/line_beam_visual.gd"))
	beam.set("beam_dir", dir)
	beam.set("beam_length", beam_length)
	beam.set("beam_width", beam_width)
	beam.set("beam_color", COLOR)
	get_tree().current_scene.add_child(beam)
