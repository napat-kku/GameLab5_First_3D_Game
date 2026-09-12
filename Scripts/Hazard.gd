extends Area3D

# Sends the player back to the last checkpoint on touch.
# Used by spikes, saw blades, spiky balls, rotating bars and the dead zone.

# ---------- FUNCTIONS ---------- #

func _ready():
	body_entered.connect(_on_body_entered)

# ---------- SIGNALS ---------- #

func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.respawn_player(body)
