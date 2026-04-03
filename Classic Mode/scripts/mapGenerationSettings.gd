extends Node

class MapSettings:
	var mapSettingName:
		get: return mapSettingName
		set(value): mapSettingName = value 
	var mapSettingDescription:
		get: return mapSettingDescription
		set(value): mapSettingDescription = value 
	var mapNoiseType:
		get: return mapNoiseType
		set(value): mapNoiseType = value
	var mapSeed:
		get: return mapSeed
		set(value): mapSeed = value
	# Smaller freq = bigger islands
	var mapFrequency:
		get: return mapFrequency
		set(value): mapFrequency = value
	var mapFractalType:
		get: return mapFractalType
		set(value): mapFractalType = value
	var mapFractalOctaves:
		get: return mapFractalOctaves
		set(value): mapFractalOctaves = value
	var mapFractalGain:
		get: return mapFractalGain
		set(value): mapFractalGain = value
	# decreasing affects how connected they are
	# works together with freq
	var mapFractalLacunarity:
		get: return mapFractalLacunarity
		set(value): mapFractalLacunarity = value
	
	func _init(
		Name := "NoName",
		Description := "NoDescription",
		NoiseType := FastNoiseLite.TYPE_SIMPLEX_SMOOTH,
		Seed := randi_range(-10000, 10000),
		Frequency := 0.05,
		FractalType := FastNoiseLite.FRACTAL_FBM,
		FractalOctaves := 8,
		FractalGain := 0.5,
		FractalLacunarity := 0.04
	) -> void:
		self.mapSettingName = Name
		self.mapSettingDescription = Description
		self.mapNoiseType = NoiseType
		self.mapSeed = Seed
		self.mapFrequency = Frequency
		self.mapFractalType = FractalType
		self.mapFractalOctaves = FractalOctaves
		self.mapFractalGain = FractalGain
		self.mapFractalLacunarity = FractalLacunarity
	
	func getFastNoise():
		var noise = FastNoiseLite.new()
		noise.noise_type = mapNoiseType
		noise.seed = mapSeed
		noise.frequency = mapFrequency
		noise.fractal_type = mapFractalType
		noise.fractal_octaves = mapFractalOctaves
		noise.fractal_gain = mapFractalGain
		noise.fractal_lacunarity = mapFractalLacunarity
		return noise

var mapList:Dictionary[String,MapSettings]
var mapNameList := ["big_map","med_map","small_map"]

func _init() -> void:
	mapList[mapNameList[0]] = MapSettings.new()
	mapList[mapNameList[0]].mapSettingName = mapNameList[0]
	
	mapList[mapNameList[1]] = MapSettings.new()
	mapList[mapNameList[1]].mapFrequency = .1
	mapList[mapNameList[1]].mapSettingName = mapNameList[1]
	
	mapList[mapNameList[2]] = MapSettings.new()
	mapList[mapNameList[2]].mapFrequency = .15
	mapList[mapNameList[2]].mapSettingName = mapNameList[2]
