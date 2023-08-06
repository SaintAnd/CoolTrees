extends TileMap

var land_tile_index = 0
var stone_tile_index = 1
var red_ore_tile_index = 2
var blue_ore_tile_index = 3

var map_width = 140
var map_height = 112
var land_threshold = 0.5
var stone_threshold = 0.8
var red_ore_threshold = 0.95
var blue_ore_threshold = 1

func _ready():
	generate_world(map_width, map_height)

func generate_world(width, height):
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for x in range(-width / 2, width / 2):
		for y in range(8, height / 2):
			var random_value = rng.randf()

			if random_value < land_threshold:
				set_cell(x, y, land_tile_index)
			elif random_value < stone_threshold:
				set_cell(x, y, stone_tile_index)
			elif random_value < red_ore_threshold:
				set_cell(x, y, red_ore_tile_index)
			elif random_value < blue_ore_threshold:
				set_cell(x, y, blue_ore_tile_index)
