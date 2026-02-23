extends Node2D

var rotation_speed := 1.0

@onready var enemy: BaseEnemy = get_parent()


func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	queue_redraw()


func _draw() -> void:
	if not enemy or not enemy.data:
		return

	var color: Color = Color.WHITE if enemy.is_hit_flashing() else enemy.data.color
	var r: float = enemy.data.radius

	match enemy.data.shape:
		"circle":
			draw_circle(Vector2.ZERO, r, color)
		"triangle":
			GeoDraw.draw_regular_polygon(self, Vector2.ZERO, r, 3, color, -PI / 2.0)
		"square":
			GeoDraw.draw_regular_polygon(self, Vector2.ZERO, r, 4, color, PI / 4.0)
		"hexagon":
			GeoDraw.draw_regular_polygon(self, Vector2.ZERO, r, 6, color)
		_:
			draw_circle(Vector2.ZERO, r, color)
