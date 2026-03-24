extends Control

enum AudioBussesEnum{
	MASTER,
	MUSIC,
	UI,
	GAME
}

@onready var ResolutionOptions := $PanelContainer/MarginContainer/VBoxContainer/ResolutionOptions
@onready var WindowModeOptions := $PanelContainer/MarginContainer/VBoxContainer/windowOptions
@onready var MasterSlider := $PanelContainer/MarginContainer/VBoxContainer/masterVolume
@onready var MusicSlider := $PanelContainer/MarginContainer/VBoxContainer/musicVolume
@onready var GUI_Slider := $PanelContainer/MarginContainer/VBoxContainer/uiVolume
@onready var GameSlider := $PanelContainer/MarginContainer/VBoxContainer/effectsVolume
@onready var MuteCheckBox := $PanelContainer/MarginContainer/VBoxContainer/muteCheckBox
@onready var VsyncCheckBox := $PanelContainer/MarginContainer/VBoxContainer/vsyncCheckBox

const MIN_VOLUME = -40.0
const MAX_VOLUME = 0.0

func _ready() -> void:
	AdjustVolumeSlidersMinMaxDecibels()
	InitializeVolume()
	LoadSavedSettings()

func LoadSavedSettings():
	for index in ResolutionOptions.item_count:
		if ResolutionOptions.get_item_text(index) == SettingsSaveManager.SettingsSave.Resolution:
			ResolutionOptions.selected = index
	
	for index in WindowModeOptions.item_count:
		if WindowModeOptions.get_item_text(index) == SettingsSaveManager.SettingsSave.WindowMode:
			WindowModeOptions.selected = index
		
	MasterSlider.value = SettingsSaveManager.SettingsSave.MasterValume
	MusicSlider.value = SettingsSaveManager.SettingsSave.MusicVolume
	GUI_Slider.value = SettingsSaveManager.SettingsSave.UI_Volume
	GameSlider.value = SettingsSaveManager.SettingsSave.GameVolume
	MuteCheckBox.button_pressed = SettingsSaveManager.SettingsSave.Muted
	VsyncCheckBox.button_pressed = SettingsSaveManager.SettingsSave.VSYNC

func AdjustVolumeSlidersMinMaxDecibels():
	(MasterSlider as HSlider).min_value = MIN_VOLUME
	(MasterSlider as HSlider).max_value = MAX_VOLUME
	
	(MusicSlider as HSlider).min_value = MIN_VOLUME
	(MusicSlider as HSlider).max_value = MAX_VOLUME
	
	(GUI_Slider as HSlider).min_value = MIN_VOLUME
	(GUI_Slider as HSlider).max_value = MAX_VOLUME
	
	(GameSlider as HSlider).min_value = MIN_VOLUME
	(GameSlider as HSlider).max_value = MAX_VOLUME

func InitializeVolume():
	var initialVolume:int = snapped(MIN_VOLUME * 1/4,1)
	MasterSlider.value = 10
	MusicSlider.value = initialVolume
	GUI_Slider.value = initialVolume
	GameSlider.value = initialVolume

func ResolutionChanged(index: int) -> void:
	UiSfx.UI_Pressed()
	match index:
		0:
			DisplayServer.window_set_size(Vector2(3940,2160))
		1:
			DisplayServer.window_set_size(Vector2(2560,1440))
		2:
			DisplayServer.window_set_size(Vector2(1920,1080))
		3:
			DisplayServer.window_set_size(Vector2(1600,900))
		4:
			DisplayServer.window_set_size(Vector2(1280,720))
		5:
			DisplayServer.window_set_size(Vector2(640,360))

func SetWindowMode(index:int):
	UiSfx.UI_Pressed()
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			ResolutionChanged(ResolutionOptions.selected)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			ResolutionChanged(ResolutionOptions.selected)

func MasterAdjustVolume(value:float):
	AudioServer.set_bus_volume_db(AudioBussesEnum.MASTER,value)

func MusicAdjustVolume(value:float):
	AudioServer.set_bus_volume_db(AudioBussesEnum.MUSIC,value)

func GUI_AdjustVolume(value:float):
	AudioServer.set_bus_volume_db(AudioBussesEnum.UI,value)

func GameAdjustVolume(value:float):
	AudioServer.set_bus_volume_db(AudioBussesEnum.GAME,value)

func MuteAll(mute:bool):
	for busIndex in AudioServer.bus_count:
		AudioServer.set_bus_mute(busIndex,mute)

func AdjustV_SYNC(enable:bool):
	if  enable == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	elif enable == false:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func SaveOptions():
	SettingsSaveManager.SettingsSave.Resolution = ResolutionOptions.get_item_text(ResolutionOptions.selected)
	SettingsSaveManager.SettingsSave.WindowMode =	WindowModeOptions.get_item_text(WindowModeOptions.selected)
	SettingsSaveManager.SettingsSave.MasterValume = MasterSlider.value
	SettingsSaveManager.SettingsSave.MusicVolume = MusicSlider.value
	SettingsSaveManager.SettingsSave.UI_Volume = GUI_Slider.value
	SettingsSaveManager.SettingsSave.GameVolume = GameSlider.value
	SettingsSaveManager.SettingsSave.Muted = MuteCheckBox.button_pressed
	SettingsSaveManager.SettingsSave.VSYNC = VsyncCheckBox.button_pressed
	SettingsSaveManager.SaveSettings()
	UiSfx.UI_Pressed()
	get_parent().visible = false

func CloseOptions():
	UiSfx.UI_Pressed()
	get_parent().visible = false

func PressedSoundPlay():
	UiSfx.UI_Pressed()

func HoverSoundPlay():
	UiSfx.UI_Hover()
