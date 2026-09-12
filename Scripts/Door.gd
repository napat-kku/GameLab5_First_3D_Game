extends Node3D

# Level exit. Stays locked until every collectible in the level has been picked up.

# ---------- VARIABLES ---------- #

@export_file("*.tscn") var next_scene: String
@export var locked_color := Color(0.85, 0.2, 0.2)
@export var open_color := Color(0.3, 0.9, 0.4)

var is_open := false

@onready var door_panel: CSGBox3D = $DoorPanel
@onready var door_light: OmniLight3D = $DoorLight
@onready var trigger: Area3D = $Trigger

# ---------- FUNCTIONS ---------- #

func _ready():
	# Each door gets its own material so opening one never recolors another
	door_panel.material = door_panel.material.duplicate()
	set_color(locked_color)
	GameManager.all_items_collected.connect(open)
	trigger.body_entered.connect(_on_trigger_body_entered)

func open():
	if is_open:
		return
	is_open = true
	set_color(open_color)

	var tween = create_tween()
	tween.tween_property(door_panel, "position:y", -1.6, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	# The player may already be waiting in front of the door
	for body in trigger.get_overlapping_bodies():
		_on_trigger_body_entered(body)

func set_color(color: Color):
	door_panel.material.albedo_color = color
	door_light.light_color = color

# ---------- SIGNALS ---------- #

func _on_trigger_body_entered(body):
	if not body.is_in_group("Player"):
		return
	if is_open:
		GameManager.change_level(next_scene)
	else:
		GameManager.show_message("Collect all fruits first! (%d / %d)" % [GameManager.score, GameManager.total_items])
