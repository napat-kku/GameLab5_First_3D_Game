extends Control

# ---------- VARIABLES ---------- #

@onready var coinsLabel = $CoinsLabel
@onready var message_label = get_node_or_null("MessageLabel")

var message_tween: Tween

# ---------- FUNCTIONS ---------- #

func _ready():
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.message_requested.connect(_on_message_requested)
	_on_score_changed(GameManager.score, GameManager.total_items)
	if message_label:
		message_label.modulate.a = 0

# ---------- SIGNALS ---------- #

func _on_score_changed(score: int, total: int):
	coinsLabel.text = "%d / %d" % [score, total]

func _on_message_requested(text: String):
	if not message_label:
		return
	message_label.text = text
	if message_tween:
		message_tween.kill()
	message_tween = create_tween()
	message_tween.tween_property(message_label, "modulate:a", 1.0, 0.2)
	message_tween.tween_interval(2.0)
	message_tween.tween_property(message_label, "modulate:a", 0.0, 0.5)
