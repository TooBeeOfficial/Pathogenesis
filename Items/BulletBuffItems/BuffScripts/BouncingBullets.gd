extends BaseItem

@export var BounceCount:int = 1

func applyItemEffect(_bullet:BaseBullet):
	if !_bullet.bulletStats.isBouncyBulletOn:
		_bullet.bulletStats.isBouncyBulletOn = true
	else:
		_bullet.bulletStats.HowManyTimesToBounce += BounceCount
