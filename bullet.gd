extends Area2D

@export var speed: float = 400.0
@export var damage: int = 5

func _ready() -> void:
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	# Move forward based on current rotation
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Check if body is a Dead Mob (Layer 2)
	# We can check collision layer bit 2 (value 2)
	# Or simply check logic if it has take_damage but is dead?
	# The requirements say: "If body is Dead Mob (Layer 2) -> Just queue_free()"
	# "If body has method take_damage (Living Mob) -> Call it"

	# If it's a living mob
	if body.has_method("take_damage"):
		# Check if it's dead? The requirement says "If body is Dead Mob (Layer 2)".
		# Living mobs are Layer 1. Dead are Layer 2.
		# A mob script has `take_damage` even if dead, but our `take_damage` returns if dead.
		# However, strictly following prompts:

		# If the body is on Layer 2 (Dead Mob / Wall)
		if body.collision_layer == 2:
			queue_free()
			return

		# If it's a Living Mob (Layer 1 usually, or just has take_damage and not Layer 2)
		body.take_damage(damage)
		queue_free()
		return

	# If body is Hero (Layer 3)
	if body.collision_layer == 4: # Bit 3 is value 4. Layer 3 -> Value 4? Godot Layers: Bit 0=1, Bit 1=2, Bit 2=4.
		# Wait, standard Godot terminology: Layer 1 = Bit 0 (Value 1). Layer 2 = Bit 1 (Value 2). Layer 3 = Bit 2 (Value 4).
		# The prompt says "Layer 3: Hero".
		# Let's check for "Hero" group or name as fallback, or just Value 4.
		print("Hero hit! Game Over / Damage Dealt")
		# Assuming Hero might have take_damage too, but prompt says "Deal damage to Hero".
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
