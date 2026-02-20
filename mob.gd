extends CharacterBody2D

@export var speed: float = 100.0
@export var hp: int = 10

var is_dead: bool = false
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Add to group "mobs" so Hero can find it
	add_to_group("mobs")

	# Layer 1: Living Mobs
	collision_layer = 1
	# Mask 1: World/Hero (as requested)
	collision_mask = 1

func _physics_process(_delta: float) -> void:
	# Move towards the target position
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

	# Visual polish - change color to gray
	modulate = Color.DIM_GRAY
	# Optional: lower z_index so living mobs walk over dead ones
	z_index = -1

	# Swap Collision Layer
	# Layer 2: Dead Mobs / Walls
	collision_layer = 2
	# Mask 0: None (static obstacle)
	collision_mask = 0

	# Stop physics processing so it becomes a static obstacle
	set_physics_process(false)
