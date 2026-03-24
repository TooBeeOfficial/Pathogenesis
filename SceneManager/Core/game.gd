extends Node

var currentGameMode:GameModeEnum.GameModes

func _ready() -> void:
	currentGameMode = GameModeEnum.GameModes.Classic
	InitializeGameModeScenes()

func InitializeGameModeScenes():
	if currentGameMode == GameModeEnum.GameModes.Classic:
		pass
	elif currentGameMode == GameModeEnum.GameModes.Dungeon:
		pass
	else:
		currentGameMode = GameModeEnum.GameModes.Classic
