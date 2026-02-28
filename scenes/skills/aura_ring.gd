extends BaseSkill

var damage := 5.0
var radius := 80.0
var visual: Node2D


func _ready() -> void:
	skill_id = "aura_ring"
	cooldown = 0.5
	cooldown_timer = cooldown
	_setup_visual()
	_on_upgrade()


func _setup_visual() -> void:
	visual = Node2D.new()
	visual.set_script(preload("res://scenes/skills/aura_ring_visual.gd"))
	if GameManager.player:
		GameManager.player.add_child(visual)


func _on_upgrade() -> void:
	match level:
		1: damage = 5.0; radius = 80.0
		2: damage = 8.0; radius = 95.0
		3: damage = 12.0; radius = 110.0
		4: damage = 16.0; radius = 125.0
		5: damage = 22.0; radius = 145.0

	if visual and visual.has_method("set_radius"):
		visual.set_radius(radius)


func activate() -> void:
	if not GameManager.player:
		return

	var player_pos := GameManager.player.global_position
	var enemies := get_tree().get_nodes_in_group("enemies")

	for enemy in enemies:
		if enemy is BaseEnemy and not enemy.is_dead:
			var dist := player_pos.distance_to(enemy.global_position)
			if dist <= radius:
				var dir: Vector2 = (enemy.global_position - player_pos).normalized()
				enemy.take_damage(damage, dir)

				# Electric modifier: chain to nearby
				if has_modifier("electric"):
					_chain_electric(enemy, damage * 0.5)


func _chain_electric(source: BaseEnemy, chain_dmg: float) -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var closest_dist := 100.0
	var closest_enemy: BaseEnemy = null

	for enemy in enemies:
		if enemy == source or not (enemy is BaseEnemy) or enemy.is_dead:
			continue
		var dist := source.global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_enemy = enemy

	if closest_enemy:
		var dir := (closest_enemy.global_position - source.global_position).normalized()
		closest_enemy.take_damage(chain_dmg, dir)
