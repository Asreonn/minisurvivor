extends CharacterBody2D

const SPEED := 280.0
const ACCEL := 1800.0
const FRICTION := 1200.0

var max_hp := 100.0
var hp := 100.0
var is_dead := false
var invincible := false
var invincible_timer := 0.0
const INVINCIBLE_DURATION := 0.5

var touch_origin := Vector2.ZERO
var touch_active := false
var input_dir := Vector2.ZERO
var facing_dir := Vector2.RIGHT

@onready var visual: Node2D = $PlayerVisual
@onready var graze_zone: Area2D = $GrazeZone
@onready var pickup_zone: Area2D = $PickupZone


func _ready() -> void:
	GameManager.player = self
	hp = max_hp
	add_to_group("player")


func _process(delta: float) -> void:
	if invincible:
		invincible_timer -= delta
		if invincible_timer <= 0.0:
			invincible = false
			modulate.a = 1.0
		else:
			modulate.a = 0.5 + 0.5 * sin(invincible_timer * 20.0)


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Keyboard input fallback
	var kb_dir := Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		kb_dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		kb_dir.x += 1
	if Input.is_action_pressed("ui_up"):
		kb_dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		kb_dir.y += 1

	var dir := input_dir if touch_active else kb_dir.normalized()

	if dir.length() > 0.1:
		velocity = velocity.move_toward(dir * SPEED, ACCEL * delta)
		facing_dir = dir.normalized()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_active = true
			touch_origin = event.position
			input_dir = Vector2.ZERO
		else:
			touch_active = false
			input_dir = Vector2.ZERO
	elif event is InputEventScreenDrag:
		if touch_active:
			var diff: Vector2 = event.position - touch_origin
			if diff.length() > 20.0:
				input_dir = diff.normalized()
			else:
				input_dir = Vector2.ZERO


func take_damage(amount: float) -> void:
	if invincible or is_dead:
		return

	hp -= amount
	invincible = true
	invincible_timer = INVINCIBLE_DURATION
	Events.player_damaged.emit(amount)
	Events.camera_shake.emit(4.0, 0.2)

	if hp <= 0.0:
		hp = 0.0
		die()


func heal(amount: float) -> void:
	hp = min(hp + amount, max_hp)
	Events.player_healed.emit(amount)


func die() -> void:
	is_dead = true
	Events.player_died.emit()
	GameManager.end_game()
