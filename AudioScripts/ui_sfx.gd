extends Node

@export var PitchLowEnd := 1.05
@export var PitchHighEnd := 1.15

func changePitch(audioPlayer:AudioStreamPlayer)->void:
	audioPlayer.pitch_scale = randf_range(PitchLowEnd,PitchHighEnd)

func UI_Hover():
	changePitch($Hover)
	$Hover.play()

func UI_Pressed():
	changePitch($Pressed)
	$Pressed.play()

func playBuffMythical():
	changePitch($BuffMythical)
	$BuffMythical.play()

func playBuffLegendary():
	changePitch($BuffLegendary)
	$BuffLegendary.play()
