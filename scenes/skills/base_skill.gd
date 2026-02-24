class_name BaseSkill
extends Node

var skill_id: String = ""
var level: int = 1
var cooldown: float = 1.0
var cooldown_timer: float = 0.0
var modifiers: Array[String] = []
var is_active := true


func _process(delta: float) -> void:
	if not is_active or not GameManager.is_running:
		return

	cooldown_timer -= delta * GameManager.get_attack_speed_mult()
	if cooldown_timer <= 0.0:
		cooldown_timer = cooldown
		activate()


func activate() -> void:
	pass  # Override in subclass


func upgrade() -> void:
	level = min(level + 1, 5)
	_on_upgrade()


func _on_upgrade() -> void:
	pass  # Override to adjust stats per level


func add_modifier(modifier_id: String) -> void:
	if modifier_id not in modifiers:
		modifiers.append(modifier_id)


func has_modifier(modifier_id: String) -> bool:
	return modifier_id in modifiers
