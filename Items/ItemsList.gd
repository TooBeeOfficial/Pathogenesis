extends Node
class_name  Items

var itemsList:Array[BaseItem]
const itemPaths:Array[String] = ["res://Items/BulletEffects/",
"res://Items/BulletBuffItems/",
"res://Items/PlayerBuffItems/",
"res://Items/PlayerBuffTimedItems/",
"res://Items/PlayerBuffAndBulletBuffEffects/"]

func _init() -> void:
	_GetItems()

func _GetItems():
	for path in itemPaths:
		for file in DirAccess.open(path).get_files():
			if (file as String).get_extension() == "tres":
				var isItem = load(path+file).duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
				if isItem is BaseItem:
					itemsList.append(load(path+file))
