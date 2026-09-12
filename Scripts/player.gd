# ----------------------------------------------------------------------------------- #
# -------------- FEEL FREE TO USE IN ANY PROJECT, COMMERCIAL OR NON-COMMERCIAL ------ #
# ---------------------- 3D PLATFORMER CONTROLLER BY SD STUDIOS --------------------- #
# ---------------------------- ATTRIBUTION NOT REQUIRED ----------------------------- #
# ----------------------------------------------------------------------------------- #

extends CharacterBody3D

# ---------- VARIABLES ---------- #

@export_category("Player Properties")
@export var move_speed : float = 6
@export var jump_force : float = 5
@export var follow_lerp_factor : float = 4
@export var jump_limit : int = 2

@export_group("Animations")
@export var idle_animation := "CharacterArmature|Idle"
@export var run_animation := "CharacterArmature|Run"
@export var jump_animation := "CharacterArmature|Jump"
@export var fall_animation := "CharacterArmature|Jump_Idle"
@export var flip_duration := 0.45

@export_group("Audio")
## The footstep loop is 0.467 s long and holds two steps.
## 0.66 stretches it to one run cycle (0.708 s) so the steps land with the feet.
@export var footstep_pitch := 0.66

@export_group("Game Juice")
@export var jumpStretchSize := Vector3(0.8, 1.2, 0.8)

# Booleans
var is_grounded = false
var can_double_jump = false

# Onready Variables
@onready var model = $Model
@onready var flip_pivot = $Model/FlipPivot
@onready var animation: AnimationPlayer = $Model/FlipPivot/Character/AnimationPlayer
@onready var spring_arm = %Gimbal

@onready var particle_trail = $ParticleTrail
@onready var footsteps = $Footsteps

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

# ---------- FUNCTIONS ---------- #

func _ready():
	# Clips imported from glTF don't loop by default
	for anim_name in [idle_animation, run_animation, fall_animation]:
		animation.get_animation(anim_name).loop_mode = Animation.LOOP_LINEAR

func _process(delta):
	player_animations()

	# Smoothly follow player's position
	spring_arm.position = lerp(spring_arm.position, position, delta * follow_lerp_factor)

	# Player Rotation
	if is_moving():
		var look_direction = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_direction.angle(), delta * 12)

# Movement runs in the physics step so moving platforms carry the player smoothly
func _physics_process(delta):
	get_input()

	# Check if player is grounded or not
	is_grounded = is_on_floor()

	# Handle Jumping
	if is_grounded:
		can_double_jump = true

	if Input.is_action_just_pressed("jump"):
		if is_grounded:
			perform_jump()
		elif can_double_jump and is_moving():
			perform_flip_jump()

	velocity.y -= gravity * delta
	move_and_slide()

func perform_jump():
	AudioManager.jump_sfx.pitch_scale = 1.12
	AudioManager.jump_sfx.play()

	jumpTween()
	animation.play(jump_animation, 0.1)
	velocity.y = jump_force

func perform_flip_jump():
	can_double_jump = false
	AudioManager.jump_sfx.pitch_scale = 0.8
	AudioManager.jump_sfx.play()
	animation.play(jump_animation, 0.1)
	velocity.y = jump_force

	# The character has no flip clip, so spin the model once around its side axis instead
	flip_pivot.rotation.x = 0
	var tween = create_tween()
	tween.tween_property(flip_pivot, "rotation:x", TAU, flip_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	flip_pivot.rotation.x = 0

func is_moving():
	return abs(velocity.z) > 0 || abs(velocity.x) > 0

# Squash the model, not the body: scaling a physics body also scales its collision
func jumpTween():
	var tween = get_tree().create_tween()
	tween.tween_property(model, "scale", jumpStretchSize, 0.1)
	tween.tween_property(model, "scale", Vector3(1,1,1), 0.1)

# Get Player Input
func get_input():
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.z = Input.get_axis("move_forward", "move_back")

	# Move The player Towards Spring Arm/Camera Rotation
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	velocity = Vector3(move_direction.x * move_speed, velocity.y, move_direction.z * move_speed)

# Handle Player Animations
func player_animations():
	particle_trail.emitting = false

	if is_on_floor():
		if is_moving(): # Checks if player is moving
			animation.play(run_animation, 0.2)
			particle_trail.emitting = true
			start_footsteps()
			return
		animation.play(idle_animation, 0.2)
	elif animation.current_animation != jump_animation:
		# Loop the in-air pose once the jump clip has finished
		animation.play(fall_animation, 0.2)

	stop_footsteps()

# Restarting the loop (instead of unpausing it) keeps the two steps inside it
# in phase with the legs every time the player sets off again
func start_footsteps():
	if not footsteps.playing:
		footsteps.pitch_scale = footstep_pitch * randf_range(0.97, 1.03)
		footsteps.play()

func stop_footsteps():
	if footsteps.playing:
		footsteps.stop()
