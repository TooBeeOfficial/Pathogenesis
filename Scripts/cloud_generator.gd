extends Node

@onready var CloudParallaxLayer := $ParallaxLayer
@onready var CloudSize := $ParallaxLayer/ColorRect

func _ready() -> void:
	CloudParallaxLayer.motion_mirroring = get_viewport().get_camera_2d().get_viewport_rect().size
	CloudSize.size = get_viewport().get_camera_2d().get_viewport_rect().size
