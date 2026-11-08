class_name Health

extends Node2D

var health := -1
var max_health := -1

signal death
signal hurt

func set_health(health_amount: int) -> void:
	health = health_amount

func set_max_health(max_health_amount: int) -> void:
	max_health = max_health_amount

func take_damage(damage: int) -> bool:
	health -= damage
	if health <= -1:
		death.emit()
		return true
	hurt.emit()
	return false
		
func heal(heal_amount: int) -> void:
	health += heal_amount
	if max_health != -1 and health > max_health:
		health = max_health
