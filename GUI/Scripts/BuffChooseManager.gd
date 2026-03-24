extends Control

var noneLegendaryMythicalEpicItemCounter = 0
const LEGENDARY_OR_MYTHICAL_OR_EPIC_GUARANTEE_NUMBER = 10

@onready var ItemOneRerollButton := $HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer2/ItemOneReroll
@onready var ItemTwoRerollButton := $HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer2/ItemTwoReroll
@onready var ItemThreeRerollButton := $HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer2/ItemThreeReroll
@onready var ItemOne := $HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/ShadowContainer/ItemOne
@onready var ItemTwo := $HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/ShadowContainer2/ItemTwo
@onready var ItemThree := $HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/ShadowContainer3/ItemThree

func _ready() -> void:
	if RerollCostLabel:
		RerollCostLabel.text = str(ItemOneRerollButton.REROLL_COST)
	var RerollOnIndex = SignalNamesList.RerollItemOnIndex
	var FinishedChoosingItem = SignalNamesList.FinishedChoosingItem
	ItemOneRerollButton.connect(RerollOnIndex,_changeItemWithIndex)
	ItemTwoRerollButton.connect(RerollOnIndex,_changeItemWithIndex)
	ItemThreeRerollButton.connect(RerollOnIndex,_changeItemWithIndex)
	ItemOne.connect(FinishedChoosingItem,OnItemChooseFinished)
	ItemTwo.connect(FinishedChoosingItem,OnItemChooseFinished)
	ItemThree.connect(FinishedChoosingItem,OnItemChooseFinished)
	SetNewItems()
	var player = (get_tree().get_first_node_in_group("Player") as Player)
	if player:
		player.connect(SignalNamesList.OpenBuffMenu,OnItemChooseFinished)

func OnItemChooseFinished(visibility:bool):
	visible = !visibility
	get_tree().paused = !visibility

func _changeItemWithIndex(index:int):
	UpdateFoodLabel()
	match index:
		0:
			ItemOne.item = getNewItem()
			await ItemOne.ApplyItemToGUI()
			ItemOne.EmitRarityParticales()
			return
		1:
			ItemTwo.item = getNewItem()
			await ItemTwo.ApplyItemToGUI()
			ItemTwo.EmitRarityParticales()
			return
		2:
			ItemThree.item = getNewItem()
			await ItemThree.ApplyItemToGUI()
			ItemThree.EmitRarityParticales()
			return

func getNewItem()->BaseItem:
	var RarityEnum = ItemRaritiesEnum.ItemRarities
	var ItemsFilteredByRarity = ItemsList.itemsList.duplicate(true).filter(_checkForRarity)
	if ItemsFilteredByRarity.is_empty():
		noneLegendaryMythicalEpicItemCounter += 1
		return ItemsList.itemsList[0]
	
	if (ItemOne.item.Rarity == RarityEnum.LEGENDARY or ItemOne.item.Rarity == RarityEnum.MYTHICAL):
		noneLegendaryMythicalEpicItemCounter = 0
	elif (ItemTwo.item.Rarity == RarityEnum.LEGENDARY or ItemTwo.item.Rarity == RarityEnum.MYTHICAL):
		noneLegendaryMythicalEpicItemCounter = 0
	elif (ItemThree.item.Rarity == RarityEnum.LEGENDARY or ItemThree.item.Rarity == RarityEnum.MYTHICAL):
		noneLegendaryMythicalEpicItemCounter = 0
	else:
		noneLegendaryMythicalEpicItemCounter += 1
	var removeExistingItemsFromList = ItemsFilteredByRarity.find(ItemOne.item)
	ItemsFilteredByRarity = removeItemFromList(removeExistingItemsFromList,ItemsFilteredByRarity)
	
	removeExistingItemsFromList = ItemsFilteredByRarity.find(ItemTwo.item)
	ItemsFilteredByRarity = removeItemFromList(removeExistingItemsFromList,ItemsFilteredByRarity)
	
	removeExistingItemsFromList = ItemsFilteredByRarity.find(ItemThree.item)
	ItemsFilteredByRarity = removeItemFromList(removeExistingItemsFromList,ItemsFilteredByRarity)
	return ItemsFilteredByRarity.pick_random()

func removeItemFromList(index:int, removeList:Array[BaseItem]):
	if index >-1 and removeList.size() > 1:
		removeList.remove_at(index)
	return removeList

func SetNewItems():
	if !ItemOne or !ItemTwo or !ItemThree:
		return
	ItemOne.item = getNewItem()
	ItemTwo.item = getNewItem()
	ItemThree.item = getNewItem()
	ItemOne.ApplyItemToGUI()
	ItemTwo.ApplyItemToGUI()
	ItemThree.ApplyItemToGUI()
	ItemOne.EmitRarityParticales()
	ItemTwo.EmitRarityParticales()
	ItemThree.EmitRarityParticales()

func _checkForRarity(item:BaseItem):
	if noneLegendaryMythicalEpicItemCounter >= LEGENDARY_OR_MYTHICAL_OR_EPIC_GUARANTEE_NUMBER:
		var legendaryOrMythical = _GetItemRarityToSpawn(randi_range(0,20))
		return item.Rarity ==  legendaryOrMythical
	
	var rare = _GetItemRarityToSpawn(randf_range(0,100))
	return item.Rarity == rare

func _GetItemRarityToSpawn(rarity: float):
	var roll := snappedi(rarity, 1)
	var RarityEnum = ItemRaritiesEnum.ItemRarities

	var mythical_max = ItemRaritiesEnum.getRaritySpawnPercent(RarityEnum.MYTHICAL)
	var legendary_max = mythical_max + ItemRaritiesEnum.getRaritySpawnPercent(RarityEnum.LEGENDARY)
	var epic_max = legendary_max + ItemRaritiesEnum.getRaritySpawnPercent(RarityEnum.EPIC)
	var rare_max = epic_max + ItemRaritiesEnum.getRaritySpawnPercent(RarityEnum.RARE)
	# common is the remainder (up to 100)

	if roll <= mythical_max:
		return RarityEnum.MYTHICAL
	elif roll <= legendary_max:
		return RarityEnum.LEGENDARY
	elif roll <= epic_max:
		return RarityEnum.EPIC
	elif roll <= rare_max:
		return RarityEnum.RARE
	else:
		return RarityEnum.COMMON

@onready var RerollCostLabel = $HBoxContainer/VBoxContainer/PanelContainer3/HBoxContainer/ReRollCost
@onready var FoodAmountLabel = $HBoxContainer/VBoxContainer/PanelContainer2/HBoxContainer/FoodLabel
func OnScreenVisibilityChanged():
	if visible == true:
		UpdateFoodLabel()
		SetNewItems()

func UpdateFoodLabel():
	var player = (get_tree().get_first_node_in_group("Player")as Player)
	if player and FoodAmountLabel:
		FoodAmountLabel.text = str(player.portalSpawnPercent)
