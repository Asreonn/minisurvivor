extends CanvasLayer

var active := true
var timer := 0.0
var bg_shapes: Array[Dictionary] = []
const BG_SHAPE_COUNT := 15


func _ready() -> void:
	layer = 40
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	get_tree().paused = true

	# Init background shapes
	var vp_size := get_tree().root.get_visible_rect().size
	for i in BG_SHAPE_COUNT:
		bg_shapes.append({
			"pos": Vector2(randf() * vp_size.x, randf() * vp_size.y),
			"speed": randf_range(10.0, 40.0),
			"size": randf_range(20.0, 60.0),
			"sides": randi_range(3, 6),
			"rot": randf() * TAU,
			"rot_speed": randf_range(-1.0, 1.0),
			"alpha": randf_range(0.03, 0.08),
		})

	var input_control := Control.new()
	input_control.name = "InputControl"
	input_control.set_anchors_preset(Control.PRESET_FULL_RECT)
	input_control.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(input_control)
	input_control.gui_input.connect(_on_input)

	var draw := Node2D.new()
	draw.name = "DrawNode"
	draw.set_script(load("res://scenes/ui/start_menu_draw.gd"))
	draw.set("menu_ref", self)
	add_child(draw)


func _process(delta: float) -> void:
	if not active:
		return
	timer += delta

	var vp_size := get_tree().root.get_visible_rect().size
	for s in bg_shapes:
		s["pos"].y += s["speed"] * delta
		s["rot"] += s["rot_speed"] * delta
		if s["pos"].y > vp_size.y + 80:
			s["pos"].y = -80.0
			s["pos"].x = randf() * vp_size.x


func _on_input(event: InputEvent) -> void:
	if not active:
		return

	if event is InputEventMouseButton and event.pressed:
		_start()
	elif event is InputEventScreenTouch and event.pressed:
		_start()


func _start() -> void:
	active = false
	visible = false
	get_tree().paused = false
