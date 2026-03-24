extends Timer
class_name FunctionCallOnTimerEnd_Timer

var currentCount = 0
var maxCount = -1
var functionToCallOnTimer:Callable
var _player

const DISABLED = -1

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("Player")

func TimerIncrementCount():
	if functionToCallOnTimer:
		functionToCallOnTimer.call(_player)
	if maxCount != DISABLED:
		currentCount += 1
		if currentCount >= maxCount:
			if self:
				print_debug("IM FREE")
				queue_free()
