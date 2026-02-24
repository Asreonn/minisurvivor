class_name XpShard
extends Area2D

const MAGNET_SPEED := 400.0
const MAGNET_ACCEL := 1200.0
const COLOR := Color(0.2, 1.0, 0.3)
const RADIUS := 4.0

var xp_value := 1
var magnetized := false
var velocity := Vector2.ZERO
var spin := 0.0
var lifetime := 30.0


func _ready() -> void:
	collision_layer = 1 << 4  # layer 5 (Pickup)
	collision_mask = 0
	add_to_group("xp_shards")

	var shape := CircleShape2D.new()
	shape.radius = RADIUS * 2
	var col := CollisionShape2D.new()
	col.shape = shape
	add_child(col)

	area_entered.connect(_on_area_entered)


func _process(delta: float) -> void:
	spin += delta * 5.0
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
		return

	if magnetized and GameManager.player:
		var dir := (GameManager.player.global_position - global_position).normalized()
		velocity = velocity.move_toward(dir * MAGNET_SPEED, MAGNET_ACCEL * delta)
		global_position += velocity * delta

		if global_position.distance_to(GameManager.player.global_position) < 20.0:
			_collect()
	elif GameManager.player:
		var pickup_range := 64.0 * GameManager.get_pickup_range_mult()
		if global_position.distance_to(GameManager.player.global_position) < pickup_range:
			magnetized = true

	queue_redraw()


func _draw() -> void:
	# Spinning diamond shape
	GeoDraw.draw_regular_polygon(self, Vector2.ZERO, RADIUS, 4, COLOR, spin)
	# Small glow
	draw_circle(Vector2.ZERO, RADIUS + 2, Color(COLOR, 0.2))


func _collect() -> void:
	GameManager.add_xp(xp_value)
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	magnetized = true
