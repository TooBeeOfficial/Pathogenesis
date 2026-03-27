extends Control

# keep player so we dont have to search for its stats
var player
# list of labels' properties used for UI stat Labels
var PlayerStatList:Array[LabelProperties] = []
# the UI element to be dynamically added
@onready var LabelScene:= preload("res://GUI/Stats.tscn")
@onready var StatsBox = $HBoxContainer/VBoxContainer/Panel/MarginContainer/StatsVerticalBoxContainer
@onready var Score = $HBoxContainer/Score

# custom class for creating UI stat labels
class LabelProperties:
	var Name:String
	var Value:float
	var Sprite:Texture
	var PlayerStatEnum:int
	
	func _init(_name:String,_value:float,_sprite:Texture,_playerStatEnum:int) -> void:
		Name = _name
		Value = _value
		Sprite = _sprite
		PlayerStatEnum = _playerStatEnum

func addNewStat(Stat:LabelProperties):
	PlayerStatList.append(Stat)

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	(player as Player).PlayerTookItemOrBuff.connect(updateExistingStats)
	updateExistingStats()

# updates stat list
func updateExistingStats():
	PlayerStatList.clear()
	var playerCombatStats := (player as Player).BaseCombat
	addNewStat(LabelProperties.new(PlayerStatsEnum.getNameFromEnum(PlayerStatsEnum.PlayerStatsEnum.PlayerFireRate),playerCombatStats.fireRate,null,PlayerStatsEnum.PlayerStatsEnum.PlayerFireRate))
	addNewStat(LabelProperties.new(PlayerStatsEnum.getNameFromEnum(PlayerStatsEnum.PlayerStatsEnum.PlayerArmor),playerCombatStats.armor,null,PlayerStatsEnum.PlayerStatsEnum.PlayerArmor))
	addNewStat(LabelProperties.new(PlayerStatsEnum.getNameFromEnum(PlayerStatsEnum.PlayerStatsEnum.PlayerSpeed),playerCombatStats.speed,null,PlayerStatsEnum.PlayerStatsEnum.PlayerSpeed))
	addNewStat(LabelProperties.new(PlayerStatsEnum.getNameFromEnum(PlayerStatsEnum.PlayerStatsEnum.PlayerMaxHealth),playerCombatStats.MaxHealth,null,PlayerStatsEnum.PlayerStatsEnum.PlayerMaxHealth))
	var bullet = playerCombatStats.bulletScene.instantiate()
	(bullet as BaseBullet).bulletStats = (bullet as BaseBullet).bulletStats.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	for buffs in playerCombatStats.bulletUpgrades:
		if buffs is BulletEffect:
			bullet.BulletEffects.append(buffs)
			# Seperate Player item uprades from BulletEffect upgrades
		buffs.applyItemEffect(bullet)
	
	addNewStat(LabelProperties.new(PlayerStatsEnum.getNameFromEnum(PlayerStatsEnum.PlayerStatsEnum.BulletDamage),bullet.calcBulletDamage(),null,PlayerStatsEnum.PlayerStatsEnum.BulletDamage))
	addNewStat(LabelProperties.new(PlayerStatsEnum.getNameFromEnum(PlayerStatsEnum.PlayerStatsEnum.BulletSpeed),bullet.bulletStats.bulletSpeed,null,PlayerStatsEnum.PlayerStatsEnum.BulletSpeed))
	bullet.queue_free()
	updateStats()

# adds updated stat label UI element
func updateStats():
	if !PlayerStatList.is_empty():
		var children := StatsBox.get_children()
		# clear children if not empty
		if !children.is_empty():
			for i in children:
				# keep stats label
				if !i.get_index() == 0:
					StatsBox.remove_child(i)
		for stat in PlayerStatList:
			var temp := LabelScene.instantiate()
			temp.StatName = stat.Name + " : " + str(snappedf(stat.Value,0.01))
			temp.StatImage = stat.Sprite
			StatsBox.add_child(temp)
