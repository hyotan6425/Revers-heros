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
	# Mask 1: World/Hero
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
	# Check for death condition
	if hp <= 0:
		die()

func die() -> void:
	# Death Logic:
	# 1. Flag as dead
	is_dead = true

	# 2. Visual polish (change color, move to background)
	modulate = Color.DIM_GRAY
	z_index = -1

	# 3. Swap Collision Layer/Mask
	# Alive: Layer 1, Mask 1 (World/Hero)
	# Dead: Layer 2 (Wall/Obstacle), Mask 0 (None)
	collision_layer = 2
	collision_mask = 0

	# 4. Stop physics processing (static obstacle)
	set_physics_process(false)
