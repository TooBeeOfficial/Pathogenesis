extends Control

class_name HealthBar

@onready var progressBar := $TextureProgressBar
@onready var progressBarLabel := $TextureProgressBar/Label

func _ready() -> void:
	var player = get_tree().get_nodes_in_group("Player")
	(player[0] as Player).onHealthChanged.connect(setPlayerHealthToProgressBar)
	
	progressBar.value = 100
	_on_texture_progress_bar_value_changed(progressBar.value)

func _on_texture_progress_bar_value_changed(value: float) -> void:
	var healthAsString := str(snappedf(value,.1))
	progressBarLabel.text = healthAsString

func setPlayerHealthToProgressBar(health:float,maxHealth:float):
	progressBar.value = ( health / maxHealth ) * 100.0
	#print_debug(progressBar.value)
