extends Node

const savePath = "user://Settings.json"

var SettingsSave:Dictionary = {
	"Resolution":"1920x1080",
	"WindowMode":"Fullscreen",
	"MasterValume": 0,
	"MusicVolume": 0,
	"UI_Volume": 0,
	"GameVolume": 0,
	"Muted": false,
	"VSYNC": false
}

func _ready() -> void:
	LoadSettings()

func SaveSettings():
	var settingsSaveFile = FileAccess.open_encrypted_with_pass(savePath,FileAccess.WRITE,"87d3y2yue")
	settingsSaveFile.store_var(SettingsSave.duplicate())
	settingsSaveFile.close()

func LoadSettings():
	if FileAccess.file_exists(savePath):
		var LoadFile = FileAccess.open_encrypted_with_pass(savePath,FileAccess.READ,"87d3y2yue")
		var getData = LoadFile.get_var()
		LoadFile.close()
		var data = getData.duplicate()
		SettingsSave.Resolution = data.Resolution
		SettingsSave.WindowMode = data.WindowMode
		SettingsSave.MasterValume = data.MasterValume
		SettingsSave.MusicVolume = data.MusicVolume
		SettingsSave.UI_Volume = data.UI_Volume
		SettingsSave.GameVolume = data.GameVolume
		SettingsSave.Muted = data.Muted
		SettingsSave.VSYNC = data.VSYNC
	else:
		SaveSettings()
		print_debug("Failed to load save")
