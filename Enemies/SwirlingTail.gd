extends Tail

@export var wiggleSpeed:float = 10
@export var wiggleStrenght:float = 2

func _ready() -> void:
	super._ready()

var elapsedTime = 0

func _physics_process(_delta: float) -> void:
	elapsedTime += _delta
	segmentPositions[0] = global_position
	for index in range(1,segmentLenght):
		var currentPos = segmentPositions[index]
		var previousPos = segmentPositions[index-1]
		var direction = previousPos - currentPos
		
		if direction.length() == 0:
			direction = Vector2.RIGHT
		else :
			direction /= direction.length()
		
		var targetPos = previousPos - direction * distance
		
		# Add snake slither perpendicular offset
		var perp = Vector2(-direction.y, direction.x)  # perpendicular vector
		var wave = sin( elapsedTime * wiggleSpeed + index * 0.5) * wiggleStrenght
		
		segmentPositions[index] = lerp(currentPos,targetPos,smoothing)+ perp * wave
	UpdateTailPositions()
