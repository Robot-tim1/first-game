extends Node2D

@onready var timer: Timer = $Timer

var player_scene: PackedScene = preload("res://scenes/player.tscn")

# default level number is -1
var current_level_number: int = 1
var current_level_scene: PackedScene
var current_level: Node
var player: Player

const LEVEL_PATHS: Array[String] = [
	"res://scenes/level_1.tscn",
	"res://scenes/level_2.tscn",
	"res://scenes/level_3.tscn",
	"res://scenes/level_4.tscn",
]

func _ready() -> void:
	_on_next_level()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		_on_reload_level()

func _on_player_setup(cords: Vector2, left: int, right: int) -> void:
	if player:
		player.queue_free()

	var new_player: Player = player_scene.instantiate()
	add_child.call_deferred(new_player)

	player = new_player
	player.camera.position_smoothing_enabled = false
	player.position = cords
	
	if left:
		player.camera.limit_left = left
	if right:
		player.camera.limit_right = right

	timer.start()

func _on_timer_timeout() -> void:
	player.camera.position_smoothing_enabled = true

func _load_level(level_scene: PackedScene) -> void:
	var loaded_level: Node = level_scene.instantiate()

	loaded_level.player_setup.connect(_on_player_setup)
	loaded_level.next_level.connect(_on_next_level)
	loaded_level.reload_level.connect(_on_reload_level)

	add_child.call_deferred(loaded_level)
	current_level = loaded_level

func _on_reload_level() -> void:
	Engine.time_scale = 1.0
	current_level.queue_free()

	_load_level(current_level_scene)

func _on_next_level() -> void:
	Engine.time_scale = 1.0
	if current_level:
		current_level.queue_free()

	current_level_number += 1
	if current_level_number >= LEVEL_PATHS.size() - 1:
		current_level_number = 1

	var level_scene: PackedScene = load(LEVEL_PATHS[current_level_number])
	current_level_scene = level_scene

	_load_level(level_scene)
