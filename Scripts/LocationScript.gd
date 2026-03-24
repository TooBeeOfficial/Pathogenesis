extends Node2D

class_name LocationPortal

@onready var WavySaderMaterial := $Sprite2D.material as ShaderMaterial

func _init() -> void:
	modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),1)
	pass

func _process(_delta):
	var t = Time.get_ticks_msec() / 2000.0
	WavySaderMaterial.set_shader_parameter("time", t)

func grow() -> void:
	scale = Vector2(1.2,1.2)
	pass # Replace with function body.

func shrink() -> void:
	scale = Vector2(1,1)
	pass # Replace with function body.


func _on_area_2d_body_exited(_body: Node2D) -> void:
	shrink()
	pass # Replace with function body.


func _on_area_2d_body_entered(_body: Node2D) -> void:
	grow()
	pass # Replace with function body.
