extends Node
class_name EnemyList

var enemies:Array[PackedScene]=[]

const pathOfEnemies = "res://Enemies/Enemies/"

func _init() -> void:
	_GetEnemies()

func _GetEnemies():
	for enemyPath in DirAccess.get_files_at(pathOfEnemies):
		if enemyPath.get_extension() == "tscn":
			var scene = load(pathOfEnemies + enemyPath)
			var instantiatedScene = scene.instantiate()
			if instantiatedScene is Enemy:
				enemies.append(scene)
