extends BaseEnemy

var shoot_timer := 0.0
var shoot_interval := 2.0
const BULLET_SPEED := 250.0
const BULLET_DAMAGE := 8.0
const BULLET_COLOR := Color(1.0, 0.6, 0.2)


func _ready() -> void:
	if not data:
		var d := EnemyData.new()
		d.id = "shooter_triangle"
		d.display_name = "Shooter"
		d.max_hp = 20.0
		d.speed = 60.0
		d.damage = 8.0
		d.xp_value = 3
		d.color = Color(1.0, 0.5, 0.1)  # orange
		d.shape = "triangle"
		d.radius = 10.0
		d.contact_damage = true
		d.shoots = true
		d.shoot_interval = 2.0
		setup(d)
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if is_dead or not GameManager.player:
		return

	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot_timer = 0.0
		_shoot()


func _shoot() -> void:
	if not GameManager.player:
		return

	var dir := (GameManager.player.global_position - global_position).normalized()
	var bullet := Area2D.new()
	bullet.global_position = global_position
	bullet.collision_layer = 1 << 3  # layer 4 (EnemyProjectile)
	bullet.collision_mask = 1 << 0   # layer 1 (Player)
	bullet.add_to_group("enemy_projectile")

	var shape := CircleShape2D.new()
	shape.radius = 4.0
	var col := CollisionShape2D.new()
	col.shape = shape
	bullet.add_child(col)

	var script := load("res://scenes/enemies/enemy_bullet.gd")
	bullet.set_script(script)
	bullet.set("direction", dir)
	bullet.set("speed", BULLET_SPEED)
	bullet.set("damage", BULLET_DAMAGE)
	bullet.set("color", BULLET_COLOR)

	get_tree().current_scene.add_child(bullet)
