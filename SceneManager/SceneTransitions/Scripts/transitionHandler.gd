extends Node
class_name LoadingScreen

@onready var transitionTimer := $SceneTransitionTimer
@onready var sceneAnimationPlayer := $LoadSceneAnimationPlayer

var animationTransitionInName:String

signal transitionCoversScreen

func startSceneTransition(animationInName:String):
	if !sceneAnimationPlayer.has_animation(animationInName):
		push_warning("'%s' animation does not exist" % animationInName)
		animationInName = "fade_in_black"
	
	animationTransitionInName = animationInName
	sceneAnimationPlayer.play(animationInName)
	transitionTimer.start()

func endSceneTransition():
	if transitionTimer:
		transitionTimer.stop()
	ScreenIsCovered()
	var animationTransitionOutName = animationTransitionInName.replace("in","out")
	if !sceneAnimationPlayer.has_animation(animationTransitionOutName):
		push_warning("'%s' animation does not exist" % animationTransitionOutName)
		animationTransitionOutName = "fade_out_black"
	
	sceneAnimationPlayer.play(animationTransitionOutName)
	await sceneAnimationPlayer.animation_finished
	queue_free()

func ScreenIsCovered():
	transitionCoversScreen.emit()
