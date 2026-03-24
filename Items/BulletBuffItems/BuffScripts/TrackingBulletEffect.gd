extends BaseItem

@export var trackingbulletBaseSpeedMultiplier:float =0.05

func applyItemEffect(_bullet:BaseBullet):
	if !_bullet.bulletStats.isTrackingBulletOn:
		_bullet.bulletStats.isTrackingBulletOn = true
	else:
		_bullet.bulletStats.TrackingBulletTrackMultiplier += trackingbulletBaseSpeedMultiplier
