class_name SkillData
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var max_level: int = 5
@export var icon_shape: String = "circle"  # for _draw icon
@export var icon_color: Color = Color.WHITE
@export var compatible_modifiers: PackedStringArray = []

# Level descriptions for card display
@export var level_descriptions: PackedStringArray = []
