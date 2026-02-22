extends Area2D

func _ready() -> void:
	# Layer 6 = GrazeZone, Mask 4 = EnemyProjectile
	collision_layer = 1 << 5  # layer 6 (0-indexed)
	collision_mask = 1 << 3   # layer 4 (EnemyProjectile)
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_projectile") and not area.has_meta("grazed"):
		area.set_meta("grazed", true)
		GameManager.add_graze()
