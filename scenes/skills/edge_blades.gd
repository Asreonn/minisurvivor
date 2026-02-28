extends BaseSkill

var blade_count := 2
var damage := 15.0
var blade_speed := 300.0
var blade_size := 12.0
var blades: Array[Dictionary] = []


func _ready() -> void:
	skill_id = "edge_blades"
	cooldown = 3.0
	cooldown_timer = cooldown
	_on_upgrade()


func _on_upgrade() -> void:
	match level:
		1: blade_count = 2; damage = 15.0; blade_speed = 300.0
		2: blade_count = 3; damage = 20.0; blade_speed = 320.0
		3: blade_count = 3; damage = 28.0; blade_speed = 350.0
		4: blade_count = 4; damage = 35.0; blade_speed = 380.0
		5: blade_count = 5; damage = 45.0; blade_speed = 420.0


func _get_camera_rect() -> Rect2:
	var camera: Camera2D = get_tree().current_scene.get_node_or_null("Camera2D")
	if not camera:
		return Rect2(-540, -960, 1080, 1920)
	var vp_size: Vector2 = get_tree().root.get_visible_rect().size / camera.zoom
	var cam_pos: Vector2 = camera.global_position
	return Rect2(cam_pos - vp_size / 2.0, vp_size)


func activate() -> void:
	var cam_rect: Rect2 = _get_camera_rect()

	for i in blade_count:
		var edge := randi() % 4
		var pos: Vector2 = Vector2.ZERO
		var dir: Vector2 = Vector2.ZERO

		match edge:
			0:  # top
				pos = Vector2(randf_range(cam_rect.position.x, cam_rect.end.x), cam_rect.position.y)
				dir = Vector2(randf_range(-0.3, 0.3), 1).normalized()
			1:  # bottom
				pos = Vector2(randf_range(cam_rect.position.x, cam_rect.end.x), cam_rect.end.y)
				dir = Vector2(randf_range(-0.3, 0.3), -1).normalized()
			2:  # left
				pos = Vector2(cam_rect.position.x, randf_range(cam_rect.position.y, cam_rect.end.y))
				dir = Vector2(1, randf_range(-0.3, 0.3)).normalized()
			3:  # right
				pos = Vector2(cam_rect.end.x, randf_range(cam_rect.position.y, cam_rect.end.y))
				dir = Vector2(-1, randf_range(-0.3, 0.3)).normalized()

		_spawn_blade(pos, dir)


func _spawn_blade(pos: Vector2, dir: Vector2) -> void:
	var blade := BaseProjectile.new()
	blade.setup(pos, dir, blade_speed, damage, Color(1.0, 1.0, 0.3))
	blade.radius = blade_size
	blade.lifetime = 8.0
	blade.can_bounce = true
	blade.screen_bounce = true  # Bounce off camera viewport, not arena
	blade.pierce_count = 999  # Pierce everything

	if has_modifier("chain"):
		blade.set_meta("chain", true)

	get_tree().current_scene.add_child(blade)
