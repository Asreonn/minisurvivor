class_name BaseProjectile
extends Area2D

var direction := Vector2.RIGHT
var speed := 400.0
var damage := 10.0
var lifetime := 3.0
var timer := 0.0
var pierce_count := 0  # 0 = no pierce, >0 = pass through N enemies
var can_bounce := false
var bounce_count := 0  # how many bounces remaining (0 = unlimited when can_bounce)
var screen_bounce := false  # bounce off screen edges instead of arena
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

	# Bounce logic
	if can_bounce:
		if screen_bounce:
			_bounce_off_screen()
		else:
			_bounce_off_arena()

	# Out of bounds removal (with margin beyond arena)
	if not screen_bounce and (abs(global_position.x) > 1200 or abs(global_position.y) > 1200):
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


func _bounce_off_arena() -> void:
	var arena_half := 1000.0
	if abs(global_position.x) > arena_half:
		direction.x *= -1
		global_position.x = signf(global_position.x) * arena_half
	if abs(global_position.y) > arena_half:
		direction.y *= -1
		global_position.y = signf(global_position.y) * arena_half


func _bounce_off_screen() -> void:
	var camera: Camera2D = get_tree().current_scene.get_node_or_null("Camera2D")
	if not camera:
		return
	var vp_size: Vector2 = get_tree().root.get_visible_rect().size / camera.zoom
	var cam_pos: Vector2 = camera.global_position
	var left: float = cam_pos.x - vp_size.x / 2.0
	var right: float = cam_pos.x + vp_size.x / 2.0
	var top: float = cam_pos.y - vp_size.y / 2.0
	var bottom: float = cam_pos.y + vp_size.y / 2.0

	if global_position.x < left:
		direction.x = absf(direction.x)
		global_position.x = left
	elif global_position.x > right:
		direction.x = -absf(direction.x)
		global_position.x = right

	if global_position.y < top:
		direction.y = absf(direction.y)
		global_position.y = top
	elif global_position.y > bottom:
		direction.y = -absf(direction.y)
		global_position.y = bottom


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
