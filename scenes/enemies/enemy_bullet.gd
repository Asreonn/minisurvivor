extends Area2D

var direction := Vector2.RIGHT
var speed := 250.0
var damage := 8.0
var color := Color(1.0, 0.6, 0.2)
var lifetime := 5.0
var timer := 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	timer += delta
	if timer >= lifetime:
		queue_free()
		return

	global_position += direction * speed * delta
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 4.0, color)
	draw_circle(Vector2.ZERO, 6.0, Color(color, 0.3))


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
