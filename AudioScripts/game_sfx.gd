extends Node

@export var PitchLowEnd := .9
@export var PitchHighEnd := 1.1

func changePitch(audioPlayer:AudioStreamPlayer)->void:
	audioPlayer.pitch_scale = randf_range(PitchLowEnd,PitchHighEnd)

func playPlayerShoot():
	changePitch($PlayerShoot)
	$PlayerShoot.play()

func playPlayerGotHit():
	changePitch($PlayerGotHit)
	$PlayerGotHit.play()

func playEnemyGotHit():
	changePitch($EnemyGotHit)
	$EnemyGotHit.play()

func playPlayerAteFood():
	changePitch($PlayerEatFood)
	$PlayerEatFood.play()
