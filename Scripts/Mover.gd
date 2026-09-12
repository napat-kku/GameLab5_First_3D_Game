extends Node3D

# Moves this node back and forth between its start position and start + move_offset.
# Works for AnimatableBody3D platforms as well as hazards.

# ---------- VARIABLES ---------- #

@export var move_offset := Vector3(0, 0, 5)
@export var duration := 2.0
@export var pause_time := 0.5

# ---------- FUNCTIONS ---------- #

func _ready():
	var start_position = position
	var tween = create_tween().set_loops()
	# Physics process keeps AnimatableBody3D in sync so the player is carried smoothly
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", start_position + move_offset, duration)
	tween.tween_interval(pause_time)
	tween.tween_property(self, "position", start_position, duration)
	tween.tween_interval(pause_time)
