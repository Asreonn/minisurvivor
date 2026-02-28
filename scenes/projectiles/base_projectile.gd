class_name BaseProjectile
extends Area2D

var direction := Vector2.RIGHT
var speed := 400.0
var damage := 10.0
var lifetime := 3.0
var timer := 0.0
var pierce_count := 0  # 0 = no pierce, >0 = pass through N enemies
var can_bounce := false
var bounced := false
var hit_enemies: Array[Node] = []
var color := Color.WHITE
var radius := 4.0
var chain_count := 0  # >0 = jump to nearby enemy on hit
var electric := false  # shock chain on hit

# Trail
var trail_positions: Array[Vector2] = []
const MAX_TRAIL := 5


func _ready() -> void:
	collision_layer = 1 << 1  # layer 2 (PlayerProjectile)
	collision_mask = 1 << 2   # layer 3 (Enemy)
	add_to_group("player_projectiles")

	var shape := CircleShape2D.new()
	shape.radius = radius
	var col := CollisionShape2D.new()
	col.shape = shape
	add_child(col)

	body_entered.connect(_on_body_entered)


func setup(pos: Vector2, dir: Vector2, spd: float, dmg: float, col: Color = Color.WHITE) -> void:
	global_position = pos
	direction = dir.normalized()
	speed = spd
	damage = dmg
	color = col


func _process(delta: float) -> void:
	timer += delta
	if timer >= lifetime:
		queue_free()
		return

	# Move
	global_position += direction * speed * delta

	# Trail
	trail_positions.push_front(global_position)
	if trail_positions.size() > MAX_TRAIL:
		trail_positions.pop_back()

	# Arena bounds bounce
	if can_bounce and not bounced:
		var arena_half := Vector2(1000, 1000)
		if abs(global_position.x) > arena_half.x:
			direction.x *= -1
			bounced = true
		if abs(global_position.y) > arena_half.y:
			direction.y *= -1
			bounced = true

	# Out of bounds removal (with margin)
	if abs(global_position.x) > 1200 or abs(global_position.y) > 1200:
		queue_free()

	queue_redraw()


func _draw() -> void:
	# Trail
	for i in trail_positions.size():
		var t := float(i) / MAX_TRAIL
		var pos: Vector2 = trail_positions[i] - global_position
		var c := Color(color, (1.0 - t) * 0.4)
		draw_circle(pos, radius * (1.0 - t * 0.5), c)

	# Main bullet
	draw_circle(Vector2.ZERO, radius, color)
	draw_circle(Vector2.ZERO, radius + 2, Color(color, 0.3))


func _on_body_entered(body: Node2D) -> void:
	if body is BaseEnemy and body not in hit_enemies:
		hit_enemies.append(body)
		var dir: Vector2 = (body.global_position - global_position).normalized()
		body.take_damage(damage, dir)

		# Hit particles
		var particles := HitParticles.new()
		particles.setup(body.global_position, color)
		get_tree().current_scene.add_child(particles)

		# Chain modifier: jump to nearby enemy
		if chain_count > 0:
			var nearest: BaseEnemy = _find_nearest_enemy(body)
			if nearest:
				chain_count -= 1
				direction = (nearest.global_position - global_position).normalized()
				return

		# Electric modifier: shock nearby
		if electric:
			_shock_nearby(body)

		if pierce_count > 0:
			pierce_count -= 1
		else:
			queue_free()


func _find_nearest_enemy(exclude: Node2D) -> BaseEnemy:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var best: BaseEnemy = null
	var best_dist := 150.0
	for enemy in enemies:
		if enemy == exclude or enemy in hit_enemies:
			continue
		if enemy is BaseEnemy and not enemy.is_dead:
			var d := global_position.distance_to(enemy.global_position)
			if d < best_dist:
				best_dist = d
				best = enemy
	return best


func _shock_nearby(source: Node2D) -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy == source:
			continue
		if enemy is BaseEnemy and not enemy.is_dead:
			if source.global_position.distance_to(enemy.global_position) < 80.0:
				enemy.take_damage(damage * 0.4, Vector2.ZERO)
				break
