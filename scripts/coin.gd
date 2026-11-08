extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pick_up_sound: AudioStreamPlayer2D = $PickUpSound

func _on_body_entered(_body: Node2D) -> void:
	game_manager.add_point.emit(10)
	pick_up_sound.pitch_scale = randf_range(0.95, 1.05)
	pick_up_sound.play()
	animation_player.play("pickup")
