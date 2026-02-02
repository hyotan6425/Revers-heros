# Main Scene Setup Instructions

## Collision Layers

Configure your Project Settings -> Layer Names -> 2D Physics:

*   **Layer 1:** `Mob` (Living Mobs)
*   **Layer 2:** `Wall` (Dead Mobs)
*   **Layer 3:** `Hero`

## Spawner Setup

To create a simple Spawner that instantiates mobs on mouse click:

1.  Create a new `Node2D` named "Spawner".
2.  Attach a script `spawner.gd`:

```gdscript
extends Node2D

@export var mob_scene: PackedScene

func _input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        spawn_mob(get_global_mouse_position())

func spawn_mob(pos: Vector2):
    if mob_scene:
        var mob = mob_scene.instantiate()
        mob.global_position = pos
        # Assuming the mob needs a target, you might set it here if you have a reference to the Hero/Objective
        # mob.set_target(Vector2(0, 0))
        get_parent().add_child(mob)
```

3.  Assign your `Mob.tscn` to the `mob_scene` export variable in the Inspector.

## Scene Tree Structure

Suggested structure for `Main.tscn`:

*   `Node2D` (Root)
    *   `Hero` (Node2D with `Hero.gd`)
        *   `Sprite2D` (Visuals)
        *   `StaticBody2D` (For collision with bullets)
            *   `CollisionShape2D`
                *   Set **Collision Layer** to 3 (Hero)
                *   Set **Collision Mask** to 1 (Mob) (if Hero gets hurt by touching mobs)
    *   `Spawner` (Node2D with `spawner.gd`)
    *   `Camera2D`

## Bullet Setup

1.  Create `Bullet.tscn` with root `Area2D`.
2.  Attach `bullet.gd`.
3.  Add `CollisionShape2D` and `Sprite2D`.
4.  Set **Collision Layer** to 0 (Bullets usually don't block things).
5.  Set **Collision Mask**:
    *   Enable Layer 1 (Mob)
    *   Enable Layer 2 (Wall)
    *   Enable Layer 3 (Hero)
    *   Value = 1 + 2 + 4 = 7 (or check the boxes manually).

## Hero Setup

1.  Attach `hero.gd` to the Hero node.
2.  Assign `Bullet.tscn` to the `bullet_scene` export variable.
