extends Node2D

@export var item: BaseItem
@onready var BaseItemSprite2D := $Sprite2D

func _ready() -> void:
	if item.ItemSprite != null:
		BaseItemSprite2D.texture = item.ItemSprite

func onBodyEntered(_body: Node2D) -> void:
	if _body is Player:
		#print_debug("EnteredBody")
		_body.addUpgrade(item)
		queue_free()
	pass
