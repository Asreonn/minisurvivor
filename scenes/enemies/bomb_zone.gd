extends Node2D

var bomb_radius := 60.0
var bomb_damage := 15.0
var telegraph_time := 1.0
var bomb_color := Color.PURPLE
var timer := 0.0
var exploded := false


func _process(delta: float) -> void:
	timer += delta

	if timer >= telegraph_time and not exploded:
		exploded = true
		_explode()

	if timer >= telegraph_time + 0.3:
		queue_free()
		return

	queue_redraw()


func _draw() -> void:
	if not exploded:
		# Telegraph: growing circle
		var t := timer / telegraph_time
		var r := bomb_radius * t
		draw_arc(Vector2.ZERO, r, 0, TAU, 32, Color(bomb_color, 0.4), 2.0)
		draw_circle(Vector2.ZERO, r, Color(bomb_color, 0.1 * t))

		# Warning pulse
		var pulse := sin(timer * 10.0) * 0.5 + 0.5
		draw_circle(Vector2.ZERO, 6, Color(bomb_color, pulse))
	else:
		# Explosion flash
		var fade := 1.0 - (timer - telegraph_time) / 0.3
		draw_circle(Vector2.ZERO, bomb_radius, Color(bomb_color, fade * 0.5))
		draw_circle(Vector2.ZERO, bomb_radius * 0.5, Color(1, 1, 1, fade * 0.3))


func _explode() -> void:
	if GameManager.player:
		var dist := global_position.distance_to(GameManager.player.global_position)
		if dist <= bomb_radius:
			GameManager.player.take_damage(bomb_damage)

	Events.camera_shake.emit(3.0, 0.15)
