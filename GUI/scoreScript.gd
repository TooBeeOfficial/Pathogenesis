extends Panel
class_name ScoreKeeper

@onready var scoreLabel = $ScoreLabel
var currentScore := 0
const SCORE_LABEL_TEXT = "Score: "

func _ready() -> void:
	# initialize score
	UpdateScore(0)
	SignalManager.updateScore.connect(UpdateScore)

func UpdateScore(score):
	currentScore += score
	scoreLabel.text = SCORE_LABEL_TEXT + str(currentScore)
