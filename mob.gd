extends CharacterBody2D

@export var speed: float = 100.0
@export var hp: int = 10

var is_dead: bool = false
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("mobs")

	# Layer 1: Mob (Living)
	collision_layer = 1

	# Mask 6: Layer 2 (Wall) + Layer 3 (Hero)
	# Value = 2 + 4 = 6.
	# NOTE: Prompt requested "Mask 1 (World/Hero)", but SETUP.md defines Hero as Layer 3
	# and Wall as Layer 2. Mask 1 would only collide with other Mobs (Layer 1).
	# Assuming intent is to collide with World/Hero, using mask 6.
	collision_mask = 6

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	# Simple navigation: move directly towards target
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
	if is_dead:
		return

	is_dead = true

	# Visual indication of death
	modulate = Color.DIM_GRAY
	z_index = -1

	# Collision Layer Swap: Become a static obstacle (Wall)
	collision_layer = 2 # Layer 2: Wall / Dead Mob
	collision_mask = 0  # No mask, doesn't collide with anything proactively

	# optimize performance by stopping physics processing
	set_physics_process(false)
