extends PanelContainer
class_name ItemReroll

@export var ItemBuffStyle:StyleBox
@export var ItemHoverStyle:StyleBox
@export var ItemPressedStyle:StyleBox

const REROLL_COST = 5
@warning_ignore("unused_signal")
signal RerollItemOnIndex(index:int)
@onready var player = (get_tree().get_first_node_in_group("Player") as Player)

func OnMouseLeave():
	if ItemBuffStyle and ItemBuffStyle != get_theme_stylebox("panel"):
		add_theme_stylebox_override("panel",ItemBuffStyle)
	UiSfx.UI_Pressed()

func OnMouseHover():
	if ItemHoverStyle and ItemHoverStyle != get_theme_stylebox("panel") and REROLL_COST <= player.portalSpawnPercent:
		add_theme_stylebox_override("panel",ItemHoverStyle)
	UiSfx.UI_Pressed()

func OnBuffChoose(_event:InputEvent):
	if Input.is_action_just_released("Shoot") and _event.is_released() and REROLL_COST <= player.portalSpawnPercent:
		add_theme_stylebox_override("panel",ItemHoverStyle)
	pass
