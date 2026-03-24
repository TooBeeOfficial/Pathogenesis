extends Node

@export var PitchLowEnd := .9
@export var PitchHighEnd := 1.1

func playBGM():
	$BGM.play()
	changePitch($BGM)

func _ready() -> void:
	if $BGM != null:
		playBGM()

func changePitch(audioPlayer:AudioStreamPlayer)->void:
	audioPlayer.pitch_scale = randf_range(PitchLowEnd,PitchHighEnd)
