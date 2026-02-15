extends CharacterBody2D

@export var speed: float = 100.0
@export var hp: int = 10

var is_dead: bool = false
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("mobs")

	# Alive state configuration
	# Layer 1: Mob
	collision_layer = 1
	# Mask 1: World/Hero (as per requirements)
	collision_mask = 1

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	# Simple movement towards target
	var direction = global_position.direction_to(target_position)
	velocity = direction * speed
	move_and_slide()

func set_target(pos: Vector2) -> void:
	target_position = pos

func take_damage(amount: int) -> void:
	if is_dead:
		return

	hp -= amount
	if hp <= 0:
		die()

func die() -> void:
	is_dead = true

	# Visual indication of death
	modulate = Color.DIM_GRAY
	z_index = -1 # Draw behind living mobs

	# Collision Layer Swap
	# Layer 2: Wall/Obstacle
	collision_layer = 2
	# Mask 0: None
	collision_mask = 0

	# Stop physics processing to become static
	set_physics_process(false)
