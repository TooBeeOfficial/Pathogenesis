extends Node2D

class_name LocationPortal
var transitionScene := "res://SceneManager/SceneTransitions/TransitionHandler.tscn"

@onready var WavySaderMaterial := $Sprite2D.material as ShaderMaterial
var newMap:MapGenerationSettings.MapSettings
var interactable:bool = false

func _ready() -> void:
	var randomMap = MapGenerationSettings.mapNameList.pick_random()
	newMap = MapGenerationSettings.mapList[randomMap]
	$Panel/Label.text = randomMap
	modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),1)
	SignalManager.generateNewMap.connect(lockLocations)

func playerEnteredArea(_body:Node2D):
	if _body is not Player:
		return
	interactable = true
	grow()

func playerExitArea(_body:Node2D):
	if _body is not Player:
		return
	interactable = false
	shrink()

func _process(_delta):
	var t = Time.get_ticks_msec() / 2000.0
	WavySaderMaterial.set_shader_parameter("time", t)

func grow() -> void:
	scale = scale * 1.2
	pass # Replace with function body.

func shrink() -> void:
	scale = scale / 1.2
	pass # Replace with function body.

func lockLocations(_location):
	if self:
		interactable = false

func onPlayerInteract():
	if interactable == false:
		return
	var TransitionSceneResource = load(transitionScene).instantiate()
	$".".add_sibling(TransitionSceneResource)
	(TransitionSceneResource as LoadingScreen).transitionCoversScreen.connect(TransitionEnd)
	(TransitionSceneResource as LoadingScreen).startSceneTransition("fade_in_black")

func TransitionEnd():
	SignalManager.generateNewMap.emit(newMap)
	queue_free()
