extends Node2D

const ARENA_SIZE := Vector2(2000, 2000)
const GRID_SPACING := 100.0
const GRID_COLOR := Color(1, 1, 1, 0.03)
const BORDER_COLOR := Color(1, 1, 1, 0.3)
const BORDER_WIDTH := 2.0

@onready var walls: StaticBody2D = $Walls


func _ready() -> void:
	_setup_walls()


func _setup_walls() -> void:
	# Create 4 wall segments
	var half := ARENA_SIZE * 0.5
	var wall_data := [
		{"pos": Vector2(0, -half.y), "size": Vector2(ARENA_SIZE.x + 40, 20)},  # top
		{"pos": Vector2(0, half.y), "size": Vector2(ARENA_SIZE.x + 40, 20)},   # bottom
		{"pos": Vector2(-half.x, 0), "size": Vector2(20, ARENA_SIZE.y + 40)},  # left
		{"pos": Vector2(half.x, 0), "size": Vector2(20, ARENA_SIZE.y + 40)},   # right
	]

	for data in wall_data:
		var shape := WorldBoundaryShape2D.new()
		# We'll use RectangleShape2D for proper collision
		var rect := RectangleShape2D.new()
		rect.size = data["size"]
		var col := CollisionShape2D.new()
		col.shape = rect
		col.position = data["pos"]
		walls.add_child(col)


func _draw() -> void:
	var half := ARENA_SIZE * 0.5

	# Background grid
	var start_x := -half.x
	while start_x <= half.x:
		draw_line(Vector2(start_x, -half.y), Vector2(start_x, half.y), GRID_COLOR)
		start_x += GRID_SPACING

	var start_y := -half.y
	while start_y <= half.y:
		draw_line(Vector2(-half.x, start_y), Vector2(half.x, start_y), GRID_COLOR)
		start_y += GRID_SPACING

	# Border
	var tl := -half
	var br := half
	draw_line(Vector2(tl.x, tl.y), Vector2(br.x, tl.y), BORDER_COLOR, BORDER_WIDTH)
	draw_line(Vector2(br.x, tl.y), Vector2(br.x, br.y), BORDER_COLOR, BORDER_WIDTH)
	draw_line(Vector2(br.x, br.y), Vector2(tl.x, br.y), BORDER_COLOR, BORDER_WIDTH)
	draw_line(Vector2(tl.x, br.y), Vector2(tl.x, tl.y), BORDER_COLOR, BORDER_WIDTH)
