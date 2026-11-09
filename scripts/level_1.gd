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
	_setup()

func _setup() -> void:
	player_setup.emit(player_cord, cam_bound_left, cam_bound_right)
	
	var hazards = get_tree().get_nodes_in_group("hazard")
	for hazard in hazards:
		hazard.player_death.connect(reload_level.emit)
