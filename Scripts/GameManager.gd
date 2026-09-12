extends Node

# ---------- SIGNALS ---------- #

signal score_changed(score: int, total: int)
signal all_items_collected
signal message_requested(text: String)

# ---------- VARIABLES ---------- #

const TITLE_SCENE := "res://Scenes/UI/TitleScreen.tscn"
const FIRST_LEVEL := "res://Scenes/Levels/Level1.tscn"

var score := 0
var total_items := 0
var respawn_position := Vector3.ZERO

# ---------- FUNCTIONS ---------- #

func _process(_delta):
	show_mouse_cursor()

# Making Cursor visible using "mouse_visible" key which is assigned in Project Settings > Input Map
func show_mouse_cursor():
	if Input.is_action_just_pressed("mouse_visible"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Called by Level.gd once every node of the level is ready
func start_level(item_count: int, spawn_position: Vector3):
	score = 0
	total_items = item_count
	respawn_position = spawn_position
	score_changed.emit(score, total_items)
	if total_items == 0:
		all_items_collected.emit()

func add_score():
	score += 1
	score_changed.emit(score, total_items)
	if score == total_items:
		all_items_collected.emit()
		show_message("All fruits collected! The EXIT is open!")

func is_level_complete() -> bool:
	return score >= total_items

func set_checkpoint(checkpoint_position: Vector3):
	respawn_position = checkpoint_position

# Sends the player back to the last checkpoint (collected items stay collected)
func respawn_player(player: CharacterBody3D):
	player.velocity = Vector3.ZERO
	player.global_position = respawn_position

func show_message(text: String):
	message_requested.emit(text)

func change_level(scene_path: String):
	# Deferred so it is safe to call from physics callbacks like body_entered
	get_tree().change_scene_to_file.call_deferred(scene_path)
