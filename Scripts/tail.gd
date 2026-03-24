extends Line2D
class_name Tail

@export var segmentLenght = 10
var segmentPositions:Array[Vector2]
@export var distance = 20
@export var Width = 20
@export var NewTexture:Texture
@export var WidthCurve:Curve
@export var smoothing:float = 0.2

var offset:Vector2
var rotationOffset:float

func _ready() -> void:
	clear_points()
	width = Width
	if NewTexture != null:
		texture = NewTexture
	offset = global_position - get_parent().global_position
	rotationOffset = global_rotation - get_parent().global_rotation
	if WidthCurve != null:
		width_curve = WidthCurve
	for i in segmentLenght:
		var p = get_parent().global_position + offset + Vector2(0, i * distance)
		segmentPositions.append(p)
		add_point(p)

func UpdateTailPositions():
	for point in range(segmentLenght):
		set_point_position(point, to_local(segmentPositions[point]))

func _physics_process(_delta: float) -> void:
	global_position = get_parent().global_position +	offset
	global_rotation = get_parent().global_rotation + rotationOffset
	segmentPositions[0] = global_position
	for index in range(1,segmentLenght):
		var currentPos = segmentPositions[index]
		var previousPos = segmentPositions[index-1]
		var direction = previousPos - currentPos
		
		if direction.length() == 0:
			direction = Vector2.RIGHT
		else :
			# normalize
			direction /= direction.length()
		
		var targetPos = previousPos - direction * distance
		
		segmentPositions[index] = lerp(currentPos,targetPos,smoothing)
	UpdateTailPositions()
