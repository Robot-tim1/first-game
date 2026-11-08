extends Node2D

signal player_setup(cords: Vector2, left: float, right: float)
signal next_level
signal reload_level

@export var player_cord: Vector2
@export var cam_bound_right: int
@export var cam_bound_left: int

func _ready() -> void:
	if has_node("finish"):
		$finish.finish_level.connect(next_level.emit)

func setup() -> void:
	player_setup.emit(player_cord, cam_bound_left, cam_bound_right)

	var all_descendants = find_children("*", "", true, true)
	for child in all_descendants:
		if child.has_signal("player_death"):
			child.player_death.connect(reload_level.emit)
