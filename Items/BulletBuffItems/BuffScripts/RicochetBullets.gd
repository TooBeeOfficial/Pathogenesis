extends BaseItem

@export var RicochetAmount:int = 1

func applyItemEffect(_bullet:BaseBullet):
	if !_bullet.bulletStats.isRichochetBulletOn:
		_bullet.bulletStats.isRichochetBulletOn = true
	else:
		_bullet.bulletStats.RichochetAmount += RicochetAmount
