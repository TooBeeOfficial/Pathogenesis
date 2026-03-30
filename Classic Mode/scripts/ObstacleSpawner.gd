extends Node2D

@warning_ignore_start("integer_division")

var NoiseGenerator: = FastNoiseLite.new()
const NoiseSize: Vector2i = Vector2i(100,100)
var noiseImage:Image
var colors := PackedColorArray()
# used to keep the largest island, removes every small island
var visited := PackedByteArray()

signal GeneratedNoise

var currentMapSettings:MapGenerationSettings.MapSettings = MapGenerationSettings.mapList[MapGenerationSettings.mapNameList[2]]

func _ready() -> void:
	initializeNoiseParametres(currentMapSettings)
	colors.resize(NoiseSize.x * NoiseSize.y)
	visited.resize(colors.size())
	visited.fill(0)

func initializeNoiseParametres(settings:MapGenerationSettings.MapSettings):
	NoiseGenerator = settings.getFastNoise()

func GenerateAndClean():
	generateNoise()
	CloseOutMap()
	keep_biggest_island()
	printColors()
	# getPlayableArea()

func printColors():
	var map = ""
	for i in colors.size():
		map += str(colors[i].b)[0]
		if (i + 1) % NoiseSize.x == 0:
			print(map)
			map = ""

func generateNoise():
	noiseImage = NoiseGenerator.get_image(NoiseSize.x,NoiseSize.y,false,false,true)
	var i: =0
	for y in NoiseSize.y:
		for x in NoiseSize.x:
			if noiseImage.get_pixelv(Vector2i(x,y)).b > .5:
				colors[i] = Color.BLACK
			else:
				colors[i] = Color.WHITE
			i += 1

func getPlayableArea():
	var tempSize = 0
	for cell in colors:
		if cell == Color.BLACK:
			tempSize += 1
	# print_debug(tempSize)
	return tempSize

func flood_fill(start: int) -> Array:
	var stack = [start]
	var region := []
	while stack.size() > 0:
		var i = stack.pop_back()
		if visited[i] == 1:
			continue
		visited[i] = 1
		region.append(i)
		var p = to_pos(i)
		for d in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var n = p + d
			if n.x < 0 or n.y < 0 or n.x >= NoiseSize.x or n.y >= NoiseSize.y:
				continue
			
			var ni = to_index(n.x, n.y)
			if colors[ni] == Color.BLACK and visited[ni] == 0:
				stack.append(ni)
	return region

func to_index(x: int, y: int) -> int:
	return y * NoiseSize.x + x

func to_pos(i: int) -> Vector2i:
	return Vector2i(i % NoiseSize.x, i / NoiseSize.x)

func keep_biggest_island():
	visited.fill(0)
	var biggest_region := []
	for i in colors.size():
		if colors[i] == Color.BLACK and visited[i] == 0:
			var region = flood_fill(i)
			if region.size() > biggest_region.size():
				biggest_region = region
	# Clear everything
	for i in colors.size():
		colors[i] = Color.WHITE
	# Restore biggest island
	for i in biggest_region:
		colors[i] = Color.BLACK
	GeneratedNoise.emit()

func CloseOutMap():
	var width = NoiseSize.x
	var height = colors.size() / width
	for i in colors.size():
		var row = i / width
		var col = i % width
		# First 2 rows or last 2 rows
		if row < 2 or row >= height - 2:
			colors[i] = Color.WHITE
			continue
		# First 2 columns or last 2 columns
		if col < 2 or col >= width - 2:
			colors[i] = Color.WHITE
