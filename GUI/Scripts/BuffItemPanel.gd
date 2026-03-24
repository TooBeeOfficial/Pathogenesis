extends PanelContainer
class_name ItemChoosePanel

@export var ItemBuffStyle:StyleBox
@export var ItemHoverStyle:StyleBox
@export var ItemBuffPressedStyle:StyleBox

@export var item:BaseItem

@onready var BuffSprite := $VBoxContainer/BuffSprite
@onready var BuffName := $VBoxContainer/BuffNameLabel
@onready var BuffDescription := $VBoxContainer/BuffDescriptionLabel
@onready var RarityEmitterLeft := $RarityLeft
@onready var RarityEmitterRight := $RarityRight
@onready var RarityShadowContainer := $".."
@onready var BuffScreen := $"../../../../../.."
@onready var _shadow = load("res://GUI/ChooseBuffScreenRarityShadow.tres")
signal FinishedChoosingItem

func _ready() -> void:
	EmitRarityParticales()
	ApplyItemToGUI()
func EmitRarityParticales():
	var RarityForColor = ItemRaritiesEnum.getRarityColor(item.Rarity)
	RarityEmitterLeft.color = RarityForColor
	RarityEmitterRight.color = RarityForColor
	
	var shadow = _shadow.duplicate()
	shadow.shadow_color = RarityForColor
	
	# Make it Rainbow if its Mythical
	if item.Rarity == ItemRaritiesEnum.ItemRarities.MYTHICAL:
		var shader = ShaderMaterial.new()
		shader.shader = load("res://Shaders/Rainbow.gdshader")
		RarityShadowContainer.material = shader
		RarityEmitterLeft.hue_variation_curve = load("res://Curves/ChooseBuffScreenHueCurve.tres")
		RarityEmitterRight.hue_variation_curve = load("res://Curves/ChooseBuffScreenHueCurve.tres")
		RarityEmitterLeft.hue_variation_max = 1
		RarityEmitterRight.hue_variation_max = 1
	else:
		RarityShadowContainer.material = null
		RarityShadowContainer.add_theme_stylebox_override("panel",shadow)
		RarityEmitterLeft.hue_variation_curve = null
		RarityEmitterRight.hue_variation_curve = null
		RarityEmitterLeft.hue_variation_max = 0
		RarityEmitterRight.hue_variation_max = 0
	RarityEmitterLeft.emitting = true
	RarityEmitterRight.emitting = true

func ApplyItemToGUI():
	if item and item.ItemName:
		BuffName.text = item.ItemName
	
	if item and item.ItemDescription:
		BuffDescription.text = item.ItemDescription
	
	if item and item.ItemSprite:
		BuffSprite.texture = item.ItemSprite
	
	if BuffScreen.visible == true:
		if item.Rarity == ItemRaritiesEnum.ItemRarities.LEGENDARY:
			UiSfx.playBuffLegendary()
		elif item.Rarity == ItemRaritiesEnum.ItemRarities.MYTHICAL:
			UiSfx.playBuffMythical()

func OnMouseLeave():
	if ItemBuffStyle and ItemBuffStyle != get_theme_stylebox("panel"):
		add_theme_stylebox_override("panel",ItemBuffStyle)
	UiSfx.UI_Pressed()

func OnMouseHover():
	if ItemHoverStyle and ItemHoverStyle != get_theme_stylebox("panel"):
		add_theme_stylebox_override("panel",ItemHoverStyle)
	UiSfx.UI_Pressed()

func OnBuffChoose(_mouseClick:InputEvent):
	if Input.is_action_pressed("Shoot") and _mouseClick.is_pressed():
		add_theme_stylebox_override("panel",ItemBuffPressedStyle)
		var getPlayer = get_tree().get_nodes_in_group("Player")[0]
		var player = (getPlayer as Player)
		if item.has_method("applyBuff"):
			player.addPlayerBuff(item)
		player.addUpgrade(item)
		emit_signal("FinishedChoosingItem",true)
	if Input.is_action_just_released("Shoot") and _mouseClick.is_released():
		add_theme_stylebox_override("panel",ItemHoverStyle)
