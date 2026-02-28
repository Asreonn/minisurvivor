extends BaseEnemy

var shoot_timer := 0.0
var shoot_interval := 3.0
const FAN_COUNT := 5
const BULLET_SPEED := 200.0
const BULLET_DAMAGE := 10.0


func _ready() -> void:
	if not data:
		var d := EnemyData.new()
		d.id = "elite_polygon"
		d.display_name = "Elite"
		d.max_hp = 80.0
		d.speed = 40.0
		d.damage = 15.0
		d.xp_value = 8
		d.color = Color(1.0, 0.85, 0.0)  # gold
		d.shape = "hexagon"
		d.radius = 16.0
		d.contact_damage = true
		d.min_spawn_time = 240.0  # after 4 minutes
		setup(d)
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if is_dead or not GameManager.player:
		return

	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot_timer = 0.0
		_shoot_fan()


func _shoot_fan() -> void:
	if not GameManager.player:
		return

	var base_dir: Vector2 = (GameManager.player.global_position - global_position).normalized()
	var base_angle := base_dir.angle()
	var spread := PI / 3.0  # 60 degree spread

	for i in FAN_COUNT:
		var t := float(i) / max(FAN_COUNT - 1, 1)
		var angle := base_angle - spread / 2.0 + spread * t
		var dir: Vector2 = Vector2(cos(angle), sin(angle))

		var bullet := Area2D.new()
		bullet.global_position = global_position
		bullet.collision_layer = 1 << 3
		bullet.collision_mask = 1 << 0
		bullet.add_to_group("enemy_projectile")

		var shape := CircleShape2D.new()
		shape.radius = 5.0
		var col := CollisionShape2D.new()
		col.shape = shape
		bullet.add_child(col)

		var script := load("res://scenes/enemies/enemy_bullet.gd")
		bullet.set_script(script)
		bullet.set("direction", dir)
		bullet.set("speed", BULLET_SPEED)
		bullet.set("damage", BULLET_DAMAGE)
		bullet.set("color", Color(1.0, 0.85, 0.0))

		get_tree().current_scene.add_child(bullet)
