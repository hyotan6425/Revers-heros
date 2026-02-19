extends CharacterBody2D

@export var speed: float = 100.0
@export var hp: int = 10

var is_dead: bool = false
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("mobs")

	# Alive state: Layer 1 (Mob), Mask 1 (World/Hero)
	collision_layer = 1
	collision_mask = 1

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

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
		_die()

func _die() -> void:
	is_dead = true

	# Visual indication
	modulate = Color.DIM_GRAY
	z_index = -1

	# Dead state: Layer 2 (Wall/Obstacle), Mask 0 (None)
	collision_layer = 2
	collision_mask = 0

	# Stop physics processing so it becomes a static obstacle
	set_physics_process(false)
