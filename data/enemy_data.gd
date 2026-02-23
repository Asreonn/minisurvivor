class_name EnemyData
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var max_hp: float = 10.0
@export var speed: float = 100.0
@export var damage: float = 10.0
@export var xp_value: int = 1
@export var color: Color = Color.RED
@export var shape: String = "circle"  # circle, triangle, square, hexagon
@export var radius: float = 8.0
@export var contact_damage: bool = true
@export var shoots: bool = false
@export var shoot_interval: float = 2.0
@export var min_spawn_time: float = 0.0  # seconds into game before this enemy can spawn
