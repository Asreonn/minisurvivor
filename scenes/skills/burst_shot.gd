extends BaseSkill

var bullet_count := 6
var damage := 8.0
var bullet_speed := 350.0
const COLOR := Color(1.0, 0.4, 0.4)


func _ready() -> void:
	skill_id = "burst_shot"
	cooldown = 2.5
	cooldown_timer = cooldown
	_on_upgrade()


func _on_upgrade() -> void:
	match level:
		1: bullet_count = 6; damage = 8.0; cooldown = 2.5
		2: bullet_count = 7; damage = 11.0; cooldown = 2.3
		3: bullet_count = 8; damage = 14.0; cooldown = 2.0
		4: bullet_count = 9; damage = 18.0; cooldown = 1.8
		5: bullet_count = 10; damage = 24.0; cooldown = 1.5


func activate() -> void:
	if not GameManager.player:
		return

	var player_pos := GameManager.player.global_position

	for i in bullet_count:
		var angle := TAU * i / bullet_count
		var dir := Vector2(cos(angle), sin(angle))

		var bullet := BaseProjectile.new()
		bullet.setup(player_pos, dir, bullet_speed, damage, COLOR)
		bullet.radius = 4.0

		if has_modifier("pierce"):
			bullet.pierce_count = 2
		if has_modifier("bounce"):
			bullet.can_bounce = true
		if has_modifier("chain"):
			bullet.chain_count = 1
		if has_modifier("electric"):
			bullet.electric = true

		get_tree().current_scene.add_child(bullet)
