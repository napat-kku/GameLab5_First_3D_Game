extends Area3D

# ---------- VARIABLES ---------- #

# You can change these values from inspector!
@export_category("Properties")
@export var follow_speed := 6
@export var amplitude := 0.2
@export var frequency := 4
@export var spin_speed := 120.0

var time_passed = 0
var is_in_range = false

# Vector
var initial_position := Vector3.ZERO

@onready var player := get_tree().get_first_node_in_group("Player")

# ---------- FUNCTIONS ---------- #

func _ready():
	initial_position = position

func _process(delta):
	coin_hover(delta) # Call the coin_hover function
	rotate_y(deg_to_rad(spin_speed) * delta)

	if is_in_range:
		follow_player(delta)

# Coin Hover Animation
func coin_hover(delta):
	time_passed += delta

	var new_y = initial_position.y + amplitude * sin(frequency * time_passed)
	position.y = new_y

func follow_player(delta):
	position += global_position.direction_to(player.global_position) * follow_speed * delta

# ---------- SIGNALS ---------- #

func _on_body_entered(body):
	# Delete The Coin and Add Score
	if body.is_in_group("Player"):
		GameManager.add_score()
		AudioManager.coin_sfx.play()
		queue_free()

func _on_range_body_entered(body):
	# Only the player attracts the coin. Resetting on other bodies (e.g. a moving platform)
	# would leave a half-shrunk coin stuck in place
	if body.is_in_group("Player") and not is_in_range:
		is_in_range = true
		# Shrink once while flying in; never to zero, or the pickup shape would vanish
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector3.ONE * 0.4, 0.4).set_ease(Tween.EASE_IN_OUT)
