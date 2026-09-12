extends Control

# ---------- VARIABLES ---------- #

@onready var play_again_button: Button = %PlayAgainButton
@onready var menu_button: Button = %MenuButton

# ---------- FUNCTIONS ---------- #

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	play_again_button.pressed.connect(_on_play_again_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	play_again_button.grab_focus()

# ---------- SIGNALS ---------- #

func _on_play_again_pressed():
	GameManager.change_level(GameManager.FIRST_LEVEL)

func _on_menu_pressed():
	GameManager.change_level(GameManager.TITLE_SCENE)
