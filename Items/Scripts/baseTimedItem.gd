extends Node2D

@export var buff: BasePlayerBuff
@export var sprite: Texture2D

@onready var BasePlayerBuffItemSprite := $Sprite2D

func _ready() -> void:
	if sprite != null:
		BasePlayerBuffItemSprite.texture = sprite

func onBodyEntered(_body: Node2D) -> void:
	if _body is Player:
		_body.addPlayerBuff(buff)
		queue_free()
	pass
