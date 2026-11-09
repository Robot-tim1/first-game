extends Damage

func _ready() -> void:
	set_damage(999)
	if self_entity is not Player:
		add_to_group("hazard")
