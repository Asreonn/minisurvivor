extends BaseEnemy

func _ready() -> void:
	if not data:
		var d := EnemyData.new()
		d.id = "swarm_dot"
		d.display_name = "Swarm Dot"
		d.max_hp = 10.0
		d.speed = 100.0
		d.damage = 10.0
		d.xp_value = 1
		d.color = Color(1.0, 0.2, 0.2)  # red
		d.shape = "circle"
		d.radius = 8.0
		d.contact_damage = true
		setup(d)
	super._ready()
