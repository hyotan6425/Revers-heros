extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 1.0

var fire_timer: Timer

func _ready() -> void:
	fire_timer = Timer.new()
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = false
	fire_timer.autostart = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)

func _on_fire_timer_timeout() -> void:
	var target = _find_nearest_living_mob()
	if target:
		_shoot_at(target)

func _find_nearest_living_mob() -> Node2D:
	var mobs = get_tree().get_nodes_in_group("mobs")
	var nearest_mob: Node2D = null
	var min_dist = INF

	for mob in mobs:
		# Check if mob is valid and not dead
		if is_instance_valid(mob) and "is_dead" in mob and not mob.is_dead:
			var dist = global_position.distance_squared_to(mob.global_position)
			if dist < min_dist:
				min_dist = dist
				nearest_mob = mob

	return nearest_mob

func _shoot_at(target: Node2D) -> void:
	if not bullet_scene:
		print("Bullet scene not assigned to Hero!")
		return

	# Look at the target
	look_at(target.global_position)

	# Instantiate bullet
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.rotation = rotation
	get_parent().add_child(bullet) # Add to world, not child of Hero (to avoid moving with hero if hero moves)
