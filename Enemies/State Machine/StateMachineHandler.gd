extends Node

@export var INIT_STATE:BaseState
var currentState:BaseState

func _ready() -> void:
	for stateChildNode in get_children():
		if stateChildNode is BaseState:
			stateChildNode.TransitionStateSignal.connect(onChildTransition)
	
	if INIT_STATE:
		INIT_STATE.EnterState()
		currentState = INIT_STATE

func _process(delta: float) -> void:
	if currentState:
		currentState.Update(delta)

func _physics_process(delta: float) -> void:
	if currentState.attachedEnemy and currentState.attachedEnemy.BaseCombat.health <= 0:
		return
	if currentState:
		currentState.PhysicsUpdate(delta)

func onChildTransition(newState:BaseState):
	if !newState:
		return
	
	if newState == currentState:
		return
	
	if currentState:
		currentState.ExitState()
	
	newState.EnterState()
	
	currentState = newState
