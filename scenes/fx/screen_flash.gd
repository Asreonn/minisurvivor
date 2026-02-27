extends CanvasLayer

var flash_color := Color.WHITE
var flash_timer := 0.0
var flash_duration := 0.15
var active := false
var draw_node: Node2D


func _ready() -> void:
	layer = 50
	draw_node = Node2D.new()
	draw_node.name = "FlashDraw"
	add_child(draw_node)
	draw_node.set_script(load("res://scenes/fx/screen_flash_draw.gd"))
	draw_node.set("flash_ref", self)
	Events.screen_flash.connect(_on_flash)


func _on_flash(color: Color, duration: float) -> void:
	flash_color = color
	flash_duration = duration
	flash_timer = 0.0
	active = true


func _process(delta: float) -> void:
	if not active:
		return
	flash_timer += delta
	if flash_timer >= flash_duration:
		active = false
