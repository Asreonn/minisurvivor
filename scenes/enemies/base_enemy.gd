class_name BaseEnemy
extends CharacterBody2D

var data: EnemyData
var hp: float
var is_dead := false
var knockback_velocity := Vector2.ZERO
var hit_flash_timer := 0.0
const HIT_FLASH_DURATION := 0.1
const KNOCKBACK_FRICTION := 800.0
const OFFSCREEN_MARGIN := 100.0

@onready var visual: Node2D = $EnemyVisual
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	add_to_group("enemies")
	collision_layer = 1 << 2  # layer 3 (Enemy)
	collision_mask = (1 << 0) | (1 << 6)  # layer 1 (Player) + layer 7 (Wall)

	if data:
		hp = data.max_hp
		var shape := CircleShape2D.new()
		shape.radius = data.radius
		collision_shape.shape = shape


func setup(enemy_data: EnemyData) -> void:
	data = enemy_data
	if is_inside_tree():
		hp = data.max_hp
		var shape := CircleShape2D.new()
		shape.radius = data.radius
		collision_shape.shape = shape


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	hit_flash_timer = max(0.0, hit_flash_timer - delta)

	# Knockback
	if knockback_velocity.length() > 10.0:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	else:
		knockback_velocity = Vector2.ZERO

	# Chase player
	var move_vel: Vector2 = Vector2.ZERO
	if GameManager.player and data:
		var dir: Vector2 = (GameManager.player.global_position - global_position).normalized()
		move_vel = dir * data.speed

	velocity = move_vel + knockback_velocity
	move_and_slide()

	# Contact damage
	if data and data.contact_damage and GameManager.player:
		var dist: float = global_position.distance_to(GameManager.player.global_position)
		if dist < data.radius + 14.0:  # 14 = player body radius
			GameManager.player.take_damage(data.damage)


func take_damage(amount: float, from_dir := Vector2.ZERO) -> void:
	if is_dead:
		return

	hp -= amount
	hit_flash_timer = HIT_FLASH_DURATION

	if from_dir != Vector2.ZERO:
		knockback_velocity = from_dir.normalized() * 200.0

	if visual:
		visual.queue_redraw()

	# Spawn damage number
	var dmg_num := preload("res://scenes/fx/damage_number.gd").new()
	dmg_num.setup(amount, global_position)
	get_tree().current_scene.add_child(dmg_num)

	if hp <= 0.0:
		die()


func die() -> void:
	is_dead = true
	Events.enemy_killed.emit(self, global_position)

	# Death burst effect
	var burst := preload("res://scenes/fx/death_burst.gd").new()
	burst.setup(global_position, data.color if data else Color.RED, data.radius if data else 8.0)
	get_tree().current_scene.add_child(burst)

	# Drop XP shard
	if data:
		var shard := XpShard.new()
		shard.xp_value = data.xp_value
		shard.global_position = global_position
		get_tree().current_scene.add_child(shard)

	queue_free()


func is_hit_flashing() -> bool:
	return hit_flash_timer > 0.0
