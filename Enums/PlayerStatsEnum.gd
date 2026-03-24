extends Node

enum PlayerStatsEnum{
	BulletDamage,
	BulletSpeed,
	PlayerSpeed,
	PlayerFireRate,
	PlayerArmor,
	PlayerMaxHealth
}

func getNameFromEnum(enumPlayerStat:int) -> String:
	match enumPlayerStat:
		PlayerStatsEnum.BulletDamage:
			return "Damage"
		PlayerStatsEnum.BulletSpeed:
			return "B.Speed"
		PlayerStatsEnum.PlayerSpeed:
			return "Speed"
		PlayerStatsEnum.PlayerFireRate:
			return "F.Rate"
		PlayerStatsEnum.PlayerArmor:
			return "Armor"
		PlayerStatsEnum.PlayerMaxHealth:
			return "M.Health"
	return "Value not found in Enum (PlayerStatsEnum). INT value: %s" %enumPlayerStat
