extends Node

var isGamePausable:bool = false
var gamePaused:bool = false

var currenState = null
var Game
var MainMenu
var BuffScreen
var Transtion

func _ready() -> void:
	currenState = MainMenu
	pass

func _process(_delta: float) -> void:
	pass
