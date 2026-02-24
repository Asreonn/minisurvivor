extends Node

var skills: Dictionary = {}  # skill_id -> BaseSkill node

# Modifier compatibility: which modifiers work with which skills
const MODIFIER_COMPAT := {
	"pierce": ["burst_shot", "front_cone"],
	"electric": ["aura_ring", "orbit_blades", "line_beam"],
	"chain": ["burst_shot", "front_cone", "edge_blades"],
	"bounce": ["burst_shot", "front_cone", "edge_blades"],
}

const SKILL_SCENES := {
	"aura_ring": "res://scenes/skills/aura_ring.gd",
	"orbit_blades": "res://scenes/skills/orbit_blades.gd",
	"edge_blades": "res://scenes/skills/edge_blades.gd",
	"burst_shot": "res://scenes/skills/burst_shot.gd",
	"front_cone": "res://scenes/skills/front_cone.gd",
	"line_beam": "res://scenes/skills/line_beam.gd",
}


func add_skill(skill_id: String) -> void:
	if skill_id in skills:
		# Upgrade existing
		skills[skill_id].upgrade()
		GameManager.active_skills[skill_id] = skills[skill_id].level
		Events.skill_upgraded.emit(skill_id, skills[skill_id].level)
		return

	if skill_id not in SKILL_SCENES:
		return

	var script := load(SKILL_SCENES[skill_id])
	var skill_node: BaseSkill = Node.new()
	skill_node.set_script(script)
	skill_node.skill_id = skill_id
	skill_node.name = skill_id
	add_child(skill_node)
	skills[skill_id] = skill_node
	GameManager.active_skills[skill_id] = 1
	Events.skill_activated.emit(skill_id)


func add_modifier(modifier_id: String, target_skill_id: String) -> void:
	if target_skill_id in skills:
		skills[target_skill_id].add_modifier(modifier_id)
		GameManager.active_modifiers[modifier_id] = target_skill_id
		Events.modifier_added.emit(modifier_id, target_skill_id)


func get_available_skills() -> Array[String]:
	var available: Array[String] = []
	for sid in SKILL_SCENES:
		if sid not in skills:
			available.append(sid)
	return available


func get_upgradeable_skills() -> Array[String]:
	var upgradeable: Array[String] = []
	for sid in skills:
		if skills[sid].level < 5:
			upgradeable.append(sid)
	return upgradeable


func get_available_modifiers() -> Array[Dictionary]:
	var available: Array[Dictionary] = []
	for mod_id in MODIFIER_COMPAT:
		if mod_id in GameManager.active_modifiers:
			continue
		for skill_id in MODIFIER_COMPAT[mod_id]:
			if skill_id in skills:
				available.append({"modifier": mod_id, "skill": skill_id})
				break
	return available
