extends Node

func _ready() -> void:
	$"MainMenu/Control/PanelContainer/TextureRect/PanelContainer/MarginContainer/VBoxContainer/Options Button".connect("OpenOptions",DisplayOptions)
	$"MainMenu/Control/PanelContainer/TextureRect/PanelContainer/MarginContainer/VBoxContainer/New Game Button".connect("NewGame",MainMenuVisibility)
	$MainMenu.visible = true
	get_tree().paused = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Menu") and $MainMenu.visible == false:
		MainMenuVisibility(true)
	elif Input.is_action_just_pressed("Menu") and $MainMenu.visible == true:
		MainMenuVisibility(false)

func DisplayOptions():
	$Options.visible = true

func MainMenuVisibility(visible:bool):
	# print_debug("MAIN MENU VISIBILITY = ", visible)
	$MainMenu.visible = visible
	get_tree().paused = visible
