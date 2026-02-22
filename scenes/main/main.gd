extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player

const CAMERA_SMOOTHING := 8.0
const CAMERA_ZOOM := Vector2(1.15, 1.15)  # Slight zoom in

# Camera shake
var shake_intensity := 0.0
var shake_timer := 0.0


func _ready() -> void:
	camera.zoom = CAMERA_ZOOM
	Events.camera_shake.connect(_on_camera_shake)
	Events.level_up.connect(_on_level_up)
	Events.player_damaged.connect(_on_player_damaged)
	# GameManager.start_game() is called here, but the tree is paused
	# by the StartMenu until the player taps to begin
	GameManager.start_game()


func _process(delta: float) -> void:
	if player and not player.is_dead:
		camera.position = camera.position.lerp(player.position, CAMERA_SMOOTHING * delta)

	# Camera shake decay
	if shake_timer > 0:
		shake_timer -= delta
		shake_intensity *= 0.9
		var offset := Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		camera.offset = offset
	else:
		shake_intensity = 0.0
		camera.offset = camera.offset.lerp(Vector2.ZERO, 10.0 * delta)


func _on_camera_shake(intensity: float, duration: float) -> void:
	if intensity > shake_intensity:
		shake_intensity = intensity
	shake_timer = max(shake_timer, duration)


func _on_level_up(_new_level: int) -> void:
	Events.screen_flash.emit(Color(1, 1, 0.8), 0.2)

	if player:
		var ring := LevelUpRing.new()
		ring.setup(player.global_position)
		add_child(ring)


func _on_player_damaged(_amount: float) -> void:
	Events.screen_flash.emit(Color(1, 0.2, 0.2), 0.15)
