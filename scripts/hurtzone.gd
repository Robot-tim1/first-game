class_name Damage

extends Area2D

signal player_death

@onready var timer: Timer = $Timer

@export var self_entity: Node2D
@export var collision: CollisionShape2D

var damage_amount := 0

func set_damage(damage: int) -> void:
	damage_amount = damage

func _on_body_entered(entity: Node2D) -> void:
	if damage_amount == 0:
		print("damage is unset")
	if entity == self_entity:
		return
	if "health_module" in entity and "dead" in entity:
		if entity.dead:
			return
		entity.health_module.take_damage(damage_amount)
		if entity is Player and entity.health_module.health <= -1:
			Engine.time_scale = 0.5
			timer.start()
	

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	player_death.emit()
