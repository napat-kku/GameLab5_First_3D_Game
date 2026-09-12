extends Control

# ---------- VARIABLES ---------- #

@onready var start_button: Button = %StartButton

# ---------- FUNCTIONS ---------- #

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_button.pressed.connect(_on_start_pressed)
	start_button.grab_focus()

# ---------- SIGNALS ---------- #

func _on_start_pressed():
	GameManager.change_level(GameManager.FIRST_LEVEL)
