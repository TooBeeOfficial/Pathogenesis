extends Resource

class_name BaseItem

@export var ItemName:String
@export var ItemDescription: String
@export var ItemSprite:Texture2D
@export var Rarity:ItemRaritiesEnum.ItemRarities = ItemRaritiesEnum.ItemRarities.COMMON

func applyItemEffect(_bullet:BaseBullet):
	#print_debug("AppliyingBase")
	pass
