extends BaseSkill

var bullet_count := 3
var damage := 10.0
var bullet_speed := 400.0
var cone_angle := PI / 4.0  # 45 degrees total spread
const COLOR := Color(1.0, 0.7, 0.2)


func _ready() -> void:
	skill_id = "front_cone"
	cooldown = 1.5
	cooldown_timer = cooldown
	_on_upgrade()


func _on_upgrade() -> void:
	match level:
		1: bullet_count = 3; damage = 10.0; cooldown = 1.5
		2: bullet_count = 4; damage = 13.0; cooldown = 1.3
		3: bullet_count = 5; damage = 17.0; cooldown = 1.2
		4: bullet_count = 5; damage = 22.0; cooldown = 1.0; cone_angle = PI / 3.0
		5: bullet_count = 7; damage = 28.0; cooldown = 0.8; cone_angle = PI / 3.0


func activate() -> void:
	if not GameManager.player:
		return

	var player_pos := GameManager.player.global_position
	var facing := GameManager.player.facing_dir
	var base_angle := facing.angle()
	var half_cone := cone_angle / 2.0

	for i in bullet_count:
		var t := float(i) / max(bullet_count - 1, 1)
		var angle := base_angle - half_cone + cone_angle * t
		var dir := Vector2(cos(angle), sin(angle))

		var bullet := BaseProjectile.new()
		bullet.setup(player_pos + facing * 20, dir, bullet_speed, damage, COLOR)
		bullet.radius = 3.5

		if has_modifier("pierce"):
			bullet.pierce_count = 1
		if has_modifier("bounce"):
			bullet.can_bounce = true
		if has_modifier("chain"):
			bullet.chain_count = 1

		get_tree().current_scene.add_child(bullet)
