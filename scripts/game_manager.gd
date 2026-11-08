extends Node

var score := 0
@onready var score_label: Label = $CanvasLayer/ScoreLabel

@warning_ignore("unused_signal")
signal add_point(point_amount: int)

func _on_add_point(point_amount: int) -> void:
	score += point_amount
	score_label.text = "Score:" + str(score)
