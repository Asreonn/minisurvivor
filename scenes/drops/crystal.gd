class_name Crystal
extends Area2D

const COLOR := Color(0.6, 0.3, 1.0)
const RADIUS := 12.0
const HP_MAX := 3

var hp := HP_MAX
var spin := 0.0


func _ready() -> void:
	collision_layer = 1 << 2  # Can be hit by player projectiles (layer 3)
	collision_mask = 1 << 1   # Mask layer 2 (PlayerProjectile)

	var shape := CircleShape2D.new()
	shape.radius = RADIUS
	var col := CollisionShape2D.new()
	col.shape = shape
	add_child(col)

	add_to_group("crystals")
	area_entered.connect(_on_hit)


func _process(delta: float) -> void:
	spin += delta * 1.5
	queue_redraw()


func _draw() -> void:
	GeoDraw.draw_glow_polygon(self, Vector2.ZERO, RADIUS, 6, COLOR, spin)

	# HP pips
	for i in hp:
		var pip_x := -6.0 + i * 6.0
		draw_circle(Vector2(pip_x, RADIUS + 6), 2.0, Color.WHITE)


func _on_hit(_area: Area2D) -> void:
	take_hit()


func take_hit() -> void:
	hp -= 1
	if hp <= 0:
		_shatter()
	else:
		# Flash
		modulate = Color.WHITE
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)


func _shatter() -> void:
	# Scatter XP
	var shard_count := randi_range(5, 8)
	for i in shard_count:
		var shard := XpShard.new()
		shard.xp_value = 2
		shard.global_position = global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
		get_tree().current_scene.add_child(shard)

	# Burst effect
	var burst := DeathBurst.new()
	burst.setup(global_position, COLOR, RADIUS)
	get_tree().current_scene.add_child(burst)

	queue_free()
