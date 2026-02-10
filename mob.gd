extends CharacterBody2D

@export var speed: float = 100.0
@export var hp: int = 10

var is_dead: bool = false
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("mobs")

	# Layer 1: Living Mobs
	collision_layer = 1
	# Mask 1: Prompt specified "Mask 1 (World/Hero)".
	# If Layer 1 is Mob, this allows collisions with other mobs/world (assuming world is Layer 1).
	collision_mask = 1

func _physics_process(_delta: float) -> void:
	# No need to check is_dead here because we call set_physics_process(false) upon death.

	# Move towards target
	var direction = global_position.direction_to(target_position)
	velocity = direction * speed
	move_and_slide()

func set_target(new_target: Vector2) -> void:
	target_position = new_target

func take_damage(amount: int) -> void:
	if is_dead:
		return

	hp -= amount
	if hp <= 0:
		die()

func die() -> void:
	is_dead = true

	# Visual feedback
	modulate = Color.DIM_GRAY
	z_index = -1

	# Collision Layer Swap
	# Layer 2: Dead Mobs / Walls
	collision_layer = 2
	# Mask 0: None (Static obstacle)
	collision_mask = 0

	# Optimization: Stop physics processing
	set_physics_process(false)
