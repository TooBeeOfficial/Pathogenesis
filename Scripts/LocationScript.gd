extends Node2D

class_name LocationPortal

@onready var WavySaderMaterial := $Sprite2D.material as ShaderMaterial
var newMap:MapGenerationSettings.MapSettings

func _ready() -> void:
	var randomMap = MapGenerationSettings.mapNameList.pick_random()
	newMap = MapGenerationSettings.mapList[randomMap]
	$Panel/Label.text = randomMap
	modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),1)
	pass

func _process(_delta):
	var t = Time.get_ticks_msec() / 2000.0
	WavySaderMaterial.set_shader_parameter("time", t)

func grow() -> void:
	scale = scale * 1.2
	pass # Replace with function body.

func shrink() -> void:
	scale = scale / 1.2
	pass # Replace with function body.

func onPlayerInteract():
	SignalManager.generateNewMap.emit(newMap)
