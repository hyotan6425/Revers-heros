extends CharacterBody2D

@export var speed: float = 100.0
@export var hp: int = 10

var is_dead: bool = false
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("mobs")

	# While Alive: Collision Layer 1 (Mob), Mask 1 (World/Hero)
	collision_layer = 1
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
	if is_dead:
		return

	is_dead = true

	# Change sprite color to indicate death
	modulate = Color.DIM_GRAY

	# Set z_index to -1 to ensure they render behind living entities
	z_index = -1

	# Collision Layer Swap: Layer 2 (Wall/Obstacle), Mask 0 (None)
	collision_layer = 2
	collision_mask = 0

	# Stop physics processing so it becomes a static obstacle
	set_physics_process(false)
