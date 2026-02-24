extends CanvasLayer

signal card_chosen(choice: Dictionary)

const CARD_WIDTH := 280.0
const CARD_HEIGHT := 160.0
const CARD_GAP := 20.0

var choices: Array[Dictionary] = []
var active := false


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	# Add input handling via Control
	var input_blocker := Control.new()
	input_blocker.name = "InputBlocker"
	input_blocker.set_anchors_preset(Control.PRESET_FULL_RECT)
	input_blocker.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(input_blocker)
	input_blocker.gui_input.connect(_on_input)

	Events.level_up.connect(_on_level_up)


func _on_level_up(_new_level: int) -> void:
	show_menu()


func show_menu() -> void:
	choices = _generate_choices()
	if choices.is_empty():
		return

	active = true
	visible = true
	get_tree().paused = true


func _generate_choices() -> Array[Dictionary]:
	var pool: Array[Dictionary] = []
	var skill_mgr: Node = _get_skill_manager()
	if not skill_mgr:
		return pool

	# New skills (if <6 active)
	var available: Array[String] = skill_mgr.get_available_skills()
	for sid in available:
		pool.append({"type": "new_skill", "skill_id": sid, "level": 1})

	# Upgrades
	var upgradeable: Array[String] = skill_mgr.get_upgradeable_skills()
	for sid in upgradeable:
		var current_lvl: int = GameManager.active_skills.get(sid, 1)
		pool.append({"type": "upgrade", "skill_id": sid, "level": current_lvl + 1})

	# Modifiers
	var mod_options: Array[Dictionary] = skill_mgr.get_available_modifiers()
	for mod in mod_options:
		pool.append({"type": "modifier", "modifier_id": mod["modifier"], "skill_id": mod["skill"]})

	# Shuffle and pick 3
	pool.shuffle()
	var result: Array[Dictionary] = []
	for i in mini(3, pool.size()):
		result.append(pool[i])
	return result


func _get_skill_manager() -> Node:
	if get_tree().current_scene:
		return get_tree().current_scene.get_node_or_null("SkillManager")
	return null


func _on_input(event: InputEvent) -> void:
	if not active:
		return

	if event is InputEventMouseButton and event.pressed:
		_handle_click(event.position)
	elif event is InputEventScreenTouch and event.pressed:
		_handle_click(event.position)


func _handle_click(pos: Vector2) -> void:
	var vp_size: Vector2 = get_tree().root.get_visible_rect().size
	var total_height: float = choices.size() * CARD_HEIGHT + (choices.size() - 1) * CARD_GAP
	var start_y: float = (vp_size.y - total_height) / 2.0
	var card_x: float = (vp_size.x - CARD_WIDTH) / 2.0

	for i in choices.size():
		var card_y: float = start_y + i * (CARD_HEIGHT + CARD_GAP)
		var rect := Rect2(card_x, card_y, CARD_WIDTH, CARD_HEIGHT)
		if rect.has_point(pos):
			_select_choice(i)
			return


func _select_choice(index: int) -> void:
	if index >= choices.size():
		return

	var choice: Dictionary = choices[index]
	var skill_mgr: Node = _get_skill_manager()
	if not skill_mgr:
		return

	match choice["type"]:
		"new_skill", "upgrade":
			skill_mgr.add_skill(choice["skill_id"])
		"modifier":
			skill_mgr.add_modifier(choice["modifier_id"], choice["skill_id"])

	active = false
	visible = false
	get_tree().paused = false
	card_chosen.emit(choice)
	Events.level_up_menu_closed.emit()
