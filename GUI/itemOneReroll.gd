extends ItemReroll

const rerollItemIndex := 0

func OnBuffChoose(_mouseClick:InputEvent):
	if Input.is_action_pressed("Shoot") and _mouseClick.is_pressed() and REROLL_COST <= player.portalSpawnPercent:
		player.portalSpawnPercent -= REROLL_COST
		add_theme_stylebox_override("panel",ItemPressedStyle)
		RerollItemOnIndex.emit(rerollItemIndex)
	super.OnBuffChoose(_mouseClick)
