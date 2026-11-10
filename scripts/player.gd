class_name Player

extends CharacterBody2D

const TOP_SPEED: float = 160.0
const SPEED: float = 130.0
const ROLLING_SPEED: float = SPEED + 50.0
const TOP_FALLING_SPEED: float = 350.0
const JUMP_VELOCITY: float = -300.0

var rolling: bool = false
var can_roll: bool = true
var hurting: bool = false
var dead: bool = false
var last_time_on_floor: int = 0
var was_on_floor: bool = true
var facing: float = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_sfx: AudioStreamPlayer2D = $hurtSFX
@onready var jump_sfx: AudioStreamPlayer2D = $jumpSFX
@onready var die_sfx: AudioStreamPlayer2D = $DIEsfx

@export var health_module: Health
@export var hurtbox: Damage
@export var camera: Camera2D

func _ready():
	health_module.set_health(3)
	hurtbox.set_damage(1)
	hurtbox.collision.set_deferred("disabled", true)

func _on_health_module_hurt() -> void:
	hurting = true
	animated_sprite.play("hurt")
	hurt_sfx.play()
	await animated_sprite.animation_finished
	hurting = false

func _on_health_module_death() -> void:
	dead = true
	animated_sprite.play("die")
	die_sfx.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "roll":
		collision_layer = 2
		rolling = false
		hurtbox.collision.set_deferred("disabled", true)

func _get_current_move(direction: float) -> String :
	if not hurting and not dead:
		if rolling:
			return "roll"
		if not is_on_floor():
			return "jump"
		if direction != 0:
			return "run"
		return "idle"
	return ""

func _apply_drag(end_speed: float, drag: float) -> void:
	if velocity.x > 0:
		velocity.x = move_toward(velocity.x, end_speed, drag)
	elif velocity.x < 0:
		velocity.x = move_toward(velocity.x, -end_speed, drag)

func _handle_jump() -> void:
	if Input.is_action_pressed("jump") and last_time_on_floor <= 6 and was_on_floor and !dead:
		collision_layer = 2
		hurtbox.collision.set_deferred("disabled", true)
		was_on_floor = false
		last_time_on_floor = 0
		velocity.y = JUMP_VELOCITY
		if rolling:
			velocity.x += facing * 20
		rolling = false
		jump_sfx.pitch_scale = randf_range(0.9, 1.1)
		jump_sfx.play()

func _handle_roll() -> void:
	if Input.is_action_just_pressed("roll") and !dead and !hurting and can_roll and !rolling:
		hurtbox.collision.set_deferred("disabled", false)
		can_roll = false
		rolling = true
		collision_layer = 8
		if !is_on_floor():
			if velocity.y > 0.0:
				velocity.y = -15.0
			else:
				velocity.y -= 15.0
		if !(velocity.x > ROLLING_SPEED or velocity.x < -ROLLING_SPEED):
			velocity.x = facing * ROLLING_SPEED

func _handle_animation(direction: float) -> void:
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	var current_state := _get_current_move(direction)
	if current_state:
		animated_sprite.play(current_state)

func _handle_movement(direction: float) -> void:
	if direction and !hurting and !dead:
		if facing != direction:
			velocity.x = direction * (SPEED / 4)
		elif velocity.x == 0.0 or (velocity.x < 0.0 and velocity.x > -SPEED) or (velocity.x > 0.0 and velocity.x < SPEED):
			velocity.x = move_toward(velocity.x, direction * SPEED,  SPEED / 4)
	elif rolling:
		_apply_drag(50.0, 4.3)
	elif !is_on_floor():
		_apply_drag(0.0, 13.0)
	else:
		_apply_drag(0.0, 32.5)

func _handle_grounded() -> void:
	if is_on_floor():
		can_roll = true
		was_on_floor = true
		last_time_on_floor = 0
		if not rolling and (velocity.x > TOP_SPEED or velocity.x < -TOP_SPEED):
			_apply_drag(TOP_SPEED, 3.2)

func _handle_midair(delta: float) -> void:
	if !is_on_floor():
		if was_on_floor:
			last_time_on_floor += 1
		if velocity.y < TOP_FALLING_SPEED:
			velocity += get_gravity() * delta
		else:
			velocity.y = TOP_FALLING_SPEED
		if !rolling and (velocity.x > TOP_SPEED or velocity.x < -TOP_SPEED):
			_apply_drag(TOP_SPEED, 1.3)

func _physics_process(delta: float) -> void:
	_handle_grounded()
	_handle_midair(delta)
	_handle_jump()
	_handle_roll()

	var direction := Input.get_axis("move_left", "move_right")

	_handle_animation(direction)
	_handle_movement(direction)

	if direction != 0:
		facing = direction

	move_and_slide()
