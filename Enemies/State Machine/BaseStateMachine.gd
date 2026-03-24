extends Node
class_name BaseState

@export var stateEnum:EnemyStatesEnum.EnemyStates

@warning_ignore("unused_signal")
signal TransitionStateSignal(currentState:BaseState,newState:BaseState)
var player
@export var attachedEnemy:Enemy

func EnterState():
	player = get_tree().get_first_node_in_group("Player")
	pass

func ExitState():
	pass

func Update(_delta: float) -> void:
	pass

func PhysicsUpdate(_delta: float) -> void:
	pass
