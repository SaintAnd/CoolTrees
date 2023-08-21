extends TileMap

var land_tile_index = 0
var stone_tile_index = 1
var red_ore_tile_index = 2
var blue_ore_tile_index = 3

var map_width = 200
var map_height = 200
var land_threshold = 1
var stone_threshold = 1
var blue_ore_probability = 0.002
var red_ore_probability = 0.99
var ore_density = 0.0
var blue_ore_cluster_density = 0.002
var blue_ore_cluster_size_range = Vector2(5, 10)
var blue_ore_cluster_spacing = 15 # Означает шаг между значениями в цикле 

var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	generate_world(map_width, map_height)

func generate_world(width, height):
	for x in range(-width / 2, width / 2):
		for y in range(-height / 2, height / 2):
			var random_value = rng.randf()

			if y >= 0 and y < 51:
				if random_value < land_threshold:  # --- Дополнительная проверка не имеет смысла как переменная land_threshold
					set_cell(x, y, land_tile_index)

	for x in range(-width / 2, width / 2): # Проходимся по всей ширине
		for y in range(51, height / 2): # Начиная с глубины 51 выполняем код до конца
			var random_value = rng.randf()

			if y <= 101: # Выполняем код до 101 блока
				if random_value < stone_threshold: # --- Дополнительная проверка не имеет смысла как переменная stone_threshold
					set_cell(x, y, stone_tile_index)

	for x in range(-width / 2, width / 2):
		for y in range(0, height / 2):
			if y < 51:
				var random_value = rng.randf()

				if random_value < blue_ore_probability:
					set_cell(x, y, blue_ore_tile_index)
# +++ Начинаем генерацию ресурсов поверх карты
	for x in range(-width / 2, width / 2, blue_ore_cluster_spacing): # Проходимся по всей ширине с шагом blue_ore_cluster_spacing
		for y in range(0, height / 2, blue_ore_cluster_spacing):
			var random_value = rng.randf()

			if random_value < blue_ore_cluster_density:
				var cluster_size = rng.randi_range(blue_ore_cluster_size_range.x, blue_ore_cluster_size_range.y)
				var half_cluster_size = cluster_size / 2
				var cluster_x_start = x - half_cluster_size
				var cluster_x_end = x + half_cluster_size
				var cluster_y_start = y - half_cluster_size
				var cluster_y_end = y + half_cluster_size

				for cluster_x in range(cluster_x_start, cluster_x_end):
					for cluster_y in range(cluster_y_start, cluster_y_end):
						if cluster_x >= -width / 2 and cluster_x <= width / 2 and cluster_y >= 0 and cluster_y < 51:
							if rng.randf() < blue_ore_probability:
								set_cell(cluster_x, cluster_y, blue_ore_tile_index)
# --- Начинаем генерацию ресурсов поверх карты
	for x in range(-width / 2, width / 2):
		for y in range(0, height / 2):
			if y < 51:
				var random_value = rng.randf()

				if random_value < ore_density:
					if rng.randf() < red_ore_probability:
						set_cell(x, y, red_ore_tile_index)
					else:
						set_cell(x, y, blue_ore_tile_index)

	for x in range(-width / 2, width / 2):
		for y in range(51, height / 2):
			var random_value = rng.randf()

			if y >= 51 and random_value < red_ore_probability:
				set_cell(x, y, red_ore_tile_index)

# Модель генерации тайлов 0.0.1
# +++++++
# Функция запускает генератор
# Генератор состоит из подфункций
# 1 Диапазон генерации
# 2 Ресурсы генерации
# 3 Форма генерации (количество блоков относительно друг друга)
# 3.1 Запустить игру "Жизнь" Как пример
# Общий вид таков:
#	ready: generate_world(
#			diapason_gen(width,height),
#			resurse_gen(resurse),
#			form_gen([wave,life,recursive,fractal])
#		)
# В глобальную функцию указываем диапазон, ресурсы и форму
# На основании этих данных происходит генерация
# -------
