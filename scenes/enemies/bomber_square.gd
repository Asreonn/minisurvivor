extends BaseEnemy

var bomb_timer := 0.0
var bomb_interval := 3.0
const BOMB_RADIUS := 60.0
const BOMB_DAMAGE := 15.0
const TELEGRAPH_DURATION := 1.0


func _ready() -> void:
	if not data:
		var d := EnemyData.new()
		d.id = "bomber_square"
		d.display_name = "Bomber"
		d.max_hp = 30.0
		d.speed = 50.0
		d.damage = 5.0
		d.xp_value = 4
		d.color = Color(0.7, 0.2, 0.9)  # purple
		d.shape = "square"
		d.radius = 12.0
		d.contact_damage = true
		setup(d)
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if is_dead:
		return

	bomb_timer += delta
	if bomb_timer >= bomb_interval:
		bomb_timer = 0.0
		_drop_bomb()


func _drop_bomb() -> void:
	var bomb := Node2D.new()
	bomb.global_position = global_position
	bomb.set_script(load("res://scenes/enemies/bomb_zone.gd"))
	bomb.set("bomb_radius", BOMB_RADIUS)
	bomb.set("bomb_damage", BOMB_DAMAGE)
	bomb.set("telegraph_time", TELEGRAPH_DURATION)
	bomb.set("bomb_color", data.color if data else Color.PURPLE)
	get_tree().current_scene.add_child(bomb)
