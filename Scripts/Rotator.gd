extends Node3D

# Spins this node continuously around its own local axes.

# ---------- VARIABLES ---------- #

## Degrees per second on each local axis
@export var rotation_speed := Vector3(0, 90, 0)

# ---------- FUNCTIONS ---------- #

func _physics_process(delta):
	var angles = rotation_speed * delta
	rotate_object_local(Vector3.RIGHT, deg_to_rad(angles.x))
	rotate_object_local(Vector3.UP, deg_to_rad(angles.y))
	rotate_object_local(Vector3.BACK, deg_to_rad(angles.z))
