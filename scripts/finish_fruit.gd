class_name Finish

extends Node2D

var player: Player

@onready var timer: Timer = $Timer

@export var cord_x: float
@export var cord_y: float

func _on_finish_detect_body_entered(entity: Node2D) -> void:
	if entity is Player:
		entity.camera.position_smoothing_enabled = false
		entity.position = Vector2(cord_x, cord_y)
		player = entity
		timer.start()

func _on_timer_timeout() -> void:
	player.camera.position_smoothing_enabled = true
