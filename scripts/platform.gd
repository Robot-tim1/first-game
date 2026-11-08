@tool
extends AnimatableBody2D

@onready var sprite: Sprite2D = $Sprite2D

@export_enum("Grass", "Dirt", "Autumn", "Ice") var type: String = "Grass":
	set(value):
		type = value
		_set_platform_type()
		queue_redraw()

func _ready() -> void:
	_set_platform_type()
	
func _set_platform_type() -> void:
	if !sprite:
		return
	var value_y: float
	match type:
		"Grass":
			value_y = 0.0
		"Dirt":
			value_y = 16.0
		"Autumn":
			value_y = 32.0
		"Ice":
			value_y = 48.0
	sprite.region_rect = Rect2(16.0, value_y, 32.0, 10.0)
