extends BaseSkill

var blade_count := 3
var orbit_radius := 60.0
var damage := 8.0
var orbit_speed := 3.0
var blade_size := 10.0
var angle := 0.0
var visual: Node2D


func _ready() -> void:
	skill_id = "orbit_blades"
	cooldown = 0.15  # tick rate for damage checks
	cooldown_timer = cooldown
	_setup_visual()
	_on_upgrade()


func _setup_visual() -> void:
	visual = Node2D.new()
	visual.set_script(load("res://scenes/skills/orbit_blades_visual.gd"))
	visual.set("skill", self)
	if GameManager.player:
		GameManager.player.add_child(visual)


func _on_upgrade() -> void:
	match level:
		1: blade_count = 3; damage = 8.0; orbit_radius = 60.0; orbit_speed = 3.0
		2: blade_count = 4; damage = 12.0; orbit_radius = 70.0; orbit_speed = 3.5
		3: blade_count = 5; damage = 16.0; orbit_radius = 80.0; orbit_speed = 4.0
		4: blade_count = 5; damage = 22.0; orbit_radius = 90.0; orbit_speed = 4.5
		5: blade_count = 6; damage = 30.0; orbit_radius = 100.0; orbit_speed = 5.0


func _process(delta: float) -> void:
	angle += orbit_speed * delta * GameManager.get_attack_speed_mult()
	super._process(delta)


func activate() -> void:
	if not GameManager.player:
		return

	var player_pos := GameManager.player.global_position
	var enemies := get_tree().get_nodes_in_group("enemies")

	for i in blade_count:
		var blade_angle := angle + TAU * i / blade_count
		var blade_pos := player_pos + Vector2(cos(blade_angle), sin(blade_angle)) * orbit_radius

		for enemy in enemies:
			if enemy is BaseEnemy and not enemy.is_dead:
				if blade_pos.distance_to(enemy.global_position) < blade_size + enemy.data.radius:
					var dir: Vector2 = (enemy.global_position - player_pos).normalized()
					enemy.take_damage(damage, dir)
