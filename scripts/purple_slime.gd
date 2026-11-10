extends CharacterBody2D

const SPEED: int = 60

@export_enum("Right", "Left") var start_direction: String = "Right"

var direction: int
var dead: bool = false
var hurting: bool = false
var is_first_frame: bool = true

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right_down: RayCast2D = $RayCastRightDown
@onready var ray_cast_left_down: RayCast2D = $RayCastLeftDown
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager

@export var hurtbox: Damage
@export var health_module: Health

func _on_health_module_hurt() -> void:
	hurting = true
	hurtbox.collision.set_deferred("disabled", true)
	animated_sprite.play("hurt")
	await animated_sprite.animation_finished
	hurting = false
	hurtbox.collision.set_deferred("disabled", false)

func _on_health_module_death() -> void:
	hurtbox.collision.set_deferred("disabled", true)
	dead = true
	animated_sprite.play("die")
	await animated_sprite.animation_finished
	queue_free()
	game_manager.add_point.emit(100)

func _ready() -> void:
	if start_direction == "Right":
		direction = 1
	if start_direction == "Left":
		animated_sprite.flip_h = true
		direction = -1
	hurtbox.set_damage(1)
	health_module.set_health(1)

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if ray_cast_right.is_colliding() or (!ray_cast_right_down.is_colliding() and !is_first_frame):
		direction = -1
		animated_sprite.flip_h = true
	
	if ray_cast_left.is_colliding() or (!ray_cast_left_down.is_colliding() and !is_first_frame):
		direction = 1
		animated_sprite.flip_h = false
	
	if not hurting and not dead:
		animated_sprite.play("idle")
	
	velocity.x = SPEED * direction
	
	if is_first_frame:
		is_first_frame = false

	move_and_slide()
