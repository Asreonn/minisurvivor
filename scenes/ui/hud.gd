extends CanvasLayer

var xp_bar_width := 0.0
const BAR_HEIGHT := 8.0
const BAR_Y := 40.0
const TIMER_COLOR := Color.WHITE
const XP_BAR_BG := Color(0.15, 0.15, 0.15)
const XP_BAR_FILL := Color(0.2, 1.0, 0.3)
const GRAZE_COLOR := Color(1.0, 0.6, 0.0)

@onready var draw_node: Node2D = $DrawNode


func _ready() -> void:
	layer = 10
	_setup_draw_node()
	Events.graze_triggered.connect(_on_graze)
	Events.overcharge_started.connect(_on_overcharge_start)
	Events.overcharge_ended.connect(_on_overcharge_end)


func _setup_draw_node() -> void:
	if not draw_node:
		draw_node = Node2D.new()
		draw_node.name = "DrawNode"
		add_child(draw_node)
	draw_node.set_script(preload("res://scenes/ui/hud_draw.gd"))


func _on_graze() -> void:
	pass


func _on_overcharge_start() -> void:
	pass


func _on_overcharge_end() -> void:
	pass
