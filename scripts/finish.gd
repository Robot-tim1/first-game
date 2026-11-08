extends Node2D

signal finish_level

func _on_finish_detect_body_entered(body: Node2D) -> void:
	if body is Player:
		finish_level.emit()
