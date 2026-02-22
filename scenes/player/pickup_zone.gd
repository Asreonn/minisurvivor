extends Area2D

const BASE_RADIUS := 64.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	# Layer 1 = Player, Mask 5 = Pickup
	collision_layer = 1 << 0  # layer 1
	collision_mask = 1 << 4   # layer 5 (Pickup)


func _process(_delta: float) -> void:
	var mult := GameManager.get_pickup_range_mult()
	if collision_shape and collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = BASE_RADIUS * mult
