extends Area3D

# Saves a new respawn point when the player walks through it.

# ---------- VARIABLES ---------- #

@export var respawn_offset := Vector3(0, 1, 0)
@export var active_color := Color(0.3, 0.9, 0.4)

var is_active := false

@onready var flag: MeshInstance3D = $Flag

# ---------- FUNCTIONS ---------- #

func _ready():
	# Each checkpoint gets its own material so activating one never recolors another
	flag.material_override = flag.material_override.duplicate()
	body_entered.connect(_on_body_entered)

func activate():
	is_active = true
	GameManager.set_checkpoint(global_position + respawn_offset)
	GameManager.show_message("Checkpoint!")
	AudioManager.coin_sfx.play()

	flag.material_override.albedo_color = active_color
	var tween = create_tween()
	tween.tween_property(flag, "position:y", 2.2, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# ---------- SIGNALS ---------- #

func _on_body_entered(body):
	if not is_active and body.is_in_group("Player"):
		activate()
