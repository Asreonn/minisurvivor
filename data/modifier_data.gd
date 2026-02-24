class_name ModifierData
extends RefCounted

const MODIFIERS := {
	"pierce": {
		"name": "Pierce",
		"description": "Projectiles pass through enemies",
		"color": Color(1.0, 0.8, 0.2),
	},
	"electric": {
		"name": "Electric",
		"description": "Hits chain lightning to nearby enemy",
		"color": Color(0.3, 0.7, 1.0),
	},
	"chain": {
		"name": "Chain",
		"description": "Hits jump to 1 nearby enemy",
		"color": Color(0.2, 1.0, 0.6),
	},
	"bounce": {
		"name": "Bounce",
		"description": "Projectiles bounce off arena walls",
		"color": Color(1.0, 0.5, 0.2),
	},
}


static func get_modifier(id: String) -> Dictionary:
	if id in MODIFIERS:
		return MODIFIERS[id]
	return {}
