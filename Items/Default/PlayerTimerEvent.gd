extends BasePlayerBuff
class_name PlayerBaseTimerItem

const timer = preload("res://Utility/timer.tscn")
@export var waitTime = 1
@export var timerLimit = -1

func applyBuff(_player:Player):
	var newTimer = timer.duplicate().instantiate()
	newTimer = (newTimer as FunctionCallOnTimerEnd_Timer)
	newTimer.functionToCallOnTimer = Callable(self,"applyTimerEffect")
	newTimer.wait_time = waitTime
	newTimer.maxCount = timerLimit
	newTimer.autostart = true
	_player.add_child(newTimer)

func applyTimerEffect(_player:Player):
	pass
