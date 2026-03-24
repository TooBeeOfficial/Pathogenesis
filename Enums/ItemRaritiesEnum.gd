extends Node

enum ItemRarities{
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
	MYTHICAL
}

func getRaritySpawnPercent(ItemRarity:ItemRarities) -> float:
	match ItemRarity:
		ItemRarities.COMMON:
			return 64
		ItemRarities.RARE:
			return 20
		ItemRarities.EPIC:
			return 10
		ItemRarities.LEGENDARY:
			return 5
		ItemRarities.MYTHICAL:
			return 1
	return 1

func getRarityColor(ItemRarity:ItemRarities) -> Color:
	match ItemRarity:
		ItemRarities.COMMON:
			return Color(255,255,255)
		ItemRarities.RARE:
			return Color.from_rgba8(44, 168, 255, 255)
		ItemRarities.EPIC:
			return Color.from_rgba8(191, 59, 255, 255)
		ItemRarities.LEGENDARY:
			return Color.from_rgba8(240, 56, 0, 255)
		ItemRarities.MYTHICAL:
			return Color.from_rgba8(0, 225, 225, 255)
	return Color()
