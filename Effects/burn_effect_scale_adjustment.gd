class_name BurnEffectAnimation
extends Node2D

@export var posiion := [0,0]

@onready var BurnEffectCPU_Particle := $BurnEffectParticle

func _ready() -> void:
	BurnEffectCPU_Particle.scale_amount_min *= scale.x
	BurnEffectCPU_Particle.scale_amount_max *= scale.x

func emitFlame(should_It_Emit:bool) ->void:
	BurnEffectCPU_Particle.emitting = should_It_Emit
