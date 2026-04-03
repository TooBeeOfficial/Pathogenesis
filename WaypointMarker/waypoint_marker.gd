extends Node2D

@export var movementSmoothing = 50
@export var screenMargin = 50
var camera:Camera2D
var player:Player

func _ready() -> void:
	camera = get_viewport().get_camera_2d()
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	if !camera:
		camera = get_viewport().get_camera_2d()
		return
	else:
		var targetPos = get_parent().global_position
		var playerToTargetDist = player.global_transform.origin.distance_to(targetPos)
		if !$"../VisibleOnScreenNotifier2D":
			return
		if $"../VisibleOnScreenNotifier2D".is_on_screen() or playerToTargetDist > 2500:
			visible = false
			return
		else:
			visible = true
		var targetRot:float
		targetPos = clamp_to_camera(targetPos)
		global_position = lerp(global_position, targetPos, delta * movementSmoothing)
		var parentRotation = get_parent().rotation
		targetRot = (global_position - player.global_position).angle() - parentRotation
		rotation = lerp_angle(rotation, targetRot, delta * movementSmoothing)

func clamp_to_camera(target_pos: Vector2) -> Vector2:
	var screen_size = get_viewport_rect().size
	var half_size = (screen_size * 0.5) / camera.zoom
	var minCameraCoord = camera.global_position - half_size
	var maxCameraCoord = camera.global_position + half_size
	return Vector2(
		clamp(target_pos.x, minCameraCoord.x + screenMargin, maxCameraCoord.x - screenMargin),
		clamp(target_pos.y, minCameraCoord.y + screenMargin, maxCameraCoord.y - screenMargin)
	)
