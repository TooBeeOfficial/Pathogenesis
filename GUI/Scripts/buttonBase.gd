extends Control
class_name MainMenuButton

@export var buttonName:String
@onready var buttonHover := $MarginContainer/button
@export var fontSize:int = 32

func _ready() -> void:
	buttonHover.text = buttonName

func buttonOnHover():
	buttonHover.add_theme_font_size_override("font_size",fontSize + 4)
	pass

func buttonOnHoverLeft():
	buttonHover.add_theme_font_size_override("font_size",fontSize)
	pass

func buttonPressed():
	pass
