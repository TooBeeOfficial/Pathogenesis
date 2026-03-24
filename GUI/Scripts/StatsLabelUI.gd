extends Control

class_name UI_StatLabel

var StatName:String
var StatImage:Texture

@onready var _StatLabel := $PanelContainer/HBoxContainer/Label
@onready var _StatTexture := $PanelContainer/HBoxContainer/TextureRect

func _ready() -> void:
	updateLabel()

func updateLabel():
	if StatName != null && StatName != "":
		_StatLabel.text = StatName
	if StatImage != null:
		_StatTexture.texture = StatImage
	else:
		_StatTexture.modulate = Color(1,0,0)
