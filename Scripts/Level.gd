extends Node3D

# Root script for every level: counts the collectibles and sets the first respawn point.

# ---------- VARIABLES ---------- #

@export var level_name := "Level"
@export var spawn_point: Marker3D

# ---------- FUNCTIONS ---------- #

func _ready():
	# Children are ready before their parent, so every item has joined the "Coin" group by now
	var item_count = get_tree().get_nodes_in_group("Coin").size()
	GameManager.start_level(item_count, spawn_point.global_position)
	GameManager.show_message(level_name)
