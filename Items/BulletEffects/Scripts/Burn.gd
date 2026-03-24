extends BulletEffect
class_name BurnEffect

@export var burnAmount = 2
@export var seconds = 5

func applyBulletEffect(body:Node2D, tree:SceneTree):
	var resetBurnTime = true
	if body is Player or body is Enemy:
		# burns will not stack
		if body.BaseCombat.isBurning == false:
			body.BaseCombat.isBurning = true
			# main delayed burn damage
			for i in seconds:
				if body == null:
					return
				body.takeDamage(burnAmount)
				# if function is called again reset timer
				if resetBurnTime == true:
					i = 0
				await tree.create_timer(1).timeout
				# if node does not exist return (body killed)
				
			if body:
				body.BaseCombat.isBurning = false
				body.takeDamage(0)

	
