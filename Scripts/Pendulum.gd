extends Node3D

# Swings this node around its local Z axis like a pendulum. Put the hazard below the pivot.

# ---------- VARIABLES ---------- #

@export var max_angle := 60.0
@export var swing_speed := 2.0
## Use different offsets so neighbouring pendulums don't swing in sync
@export var phase_offset := 0.0

var time_passed := 0.0

# ---------- FUNCTIONS ---------- #

func _physics_process(delta):
	time_passed += delta
	rotation.z = deg_to_rad(max_angle) * sin(time_passed * swing_speed + phase_offset)
