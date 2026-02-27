extends CanvasLayer

var active := false
var survived_time := 0.0
var count_timer := 0.0
var stats_shown := 0

const BG_COLOR := Color(0, 0, 0, 0.8)
const TITLE_COLOR := Color(1.0, 0.3, 0.3)


func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	var input_control := Control.new()
	input_control.name = "InputControl"
	input_control.set_anchors_preset(Control.PRESET_FULL_RECT)
	input_control.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(input_control)
	input_control.gui_input.connect(_on_input)

	var draw := Node2D.new()
	draw.name = "DrawNode"
	draw.set_script(load("res://scenes/ui/game_over_draw.gd"))
	draw.set("menu_ref", self)
	add_child(draw)

	Events.game_over.connect(_on_game_over)


func _on_game_over(time: float) -> void:
	survived_time = time
	active = true
	visible = true
	count_timer = 0.0
	stats_shown = 0
	get_tree().paused = true


func _process(delta: float) -> void:
	if not active:
		return
	count_timer += delta
	stats_shown = mini(int(count_timer / 0.3), 5)


func _on_input(event: InputEvent) -> void:
	if not active:
		return

	var clicked := false
	if event is InputEventMouseButton and event.pressed:
		clicked = true
	elif event is InputEventScreenTouch and event.pressed:
		clicked = true

	if clicked and count_timer > 1.5:
		_restart()


func _restart() -> void:
	active = false
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
