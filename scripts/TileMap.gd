extends TileMap

var land_tile_index = 0
var stone_tile_index = 1
var red_ore_tile_index = 2
var blue_ore_tile_index = 3

var map_width = 200
var map_height = 200
var map_start_mid_height = map_height/6 # Начало глубины среднего слоя
var map_end_mid_height = map_height/3.8 # Конец глубины среднего слоя
var chance_mid_draw = 0.02 # Вероятность заливки среднего слоя
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
	generate_ground(map_width, map_start_mid_height, map_end_mid_height, chance_mid_draw, red_ore_tile_index)
	set_cell(5,1,1)
	set_cell(6,2,1)
	set_cell(4,3,1)
	set_cell(5,3,1)
	set_cell(6,3,1)
	
func _process(delta):
	# Задаём клеточному автомату размер и место
	automataTemplate(map_width, map_height, map_start_mid_height, map_end_mid_height)

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
				
func generate_ground(width, start_height, end_height, chance, tile_index):
# --- Начинаем генерацию промежутков двух слоёв
	for y in range(start_height, end_height): # Проходимся по высоте
		for x in range(-width / 2, width / 2): # Проходимся по всей ширине
			var random_value = rng.randf()
			if random_value < chance: # Задаём уровень случайности
				set_cell(x, y, tile_index) # Замещаем ячейку на нужную
				chance += 0.001

func automataTemplate(width,height,position_x,position_y):
# Обнуляем клеточному автомату сетки жизни и смерти
	var grid_life = []
	var grid_death = []
# Вводим константы включеных и отключеных клеток
	var ON = 1
	var OFF = 0
# Задаём размер сетки для деления по модулю
	var N = width*height
# Проходим по полю ширины и высоты
	for x in range (width):
		for y in range (height):
			# Сбрасываем счётчик соседей на нуль
			var neighbors = 0
			# Проверяме соседей с 8-ми сторон живи ли они
			# Если да, то добавляем в счётчик
			# Делаем фигуру "тор" с помощью деления по модулю
			if get_cell(x,(y-1)%N) == ON:				neighbors += 1
			if get_cell(x,(y+1)%N) == ON:				neighbors += 1
			if get_cell((x-1)%N,y) == ON:				neighbors += 1
			if get_cell((x+1)%N,y) == ON:				neighbors += 1
			if get_cell((x-1)%N,(y-1)%N) == ON:				neighbors += 1
			if get_cell((x-1)%N,(y+1)%N) == ON:				neighbors += 1
			if get_cell((x+1)%N,(y-1)%N) == ON:				neighbors += 1
			if get_cell((x+1)%N,(y+1)%N) == ON:				neighbors += 1
			
			# Здесь главное условие игры B3/S23
			# Если 3 живых клетки рядом, то создаём живую вместо мёртвой
			# Если рядом меньше 2-ух и больше 3-ёх, то убиваем клетку
			if get_cell(x, y) == ON:
				if (neighbors < 2) or (neighbors > 3):
					grid_death.append(Vector2(x,y))
			else:
				if neighbors == 3:
					grid_life.append(Vector2(x,y))
# Проходим по таблице смерти и убиваем клетки
	for t in grid_death:
		print ("start_DEL:" + str(t))
		set_cellv(t,OFF)
		print ("end_DEL:" + str(t))
	print (grid_death)
# Проходим по таблице жизни и оживляем клетки
	for t in grid_life:
		print ("start_ON:" + str(t))
		set_cellv(t,ON)
		print ("end_ON:" + str(t))
	print (str(grid_life))
	
# Модель генерации тайлов 0.0.1
# +++++++
# Функция запускает генератор
# Генератор состоит из подфункций
# 1 Диапазон генерации
# 2 Ресурсы генерации
# 3 Форма генерации (количество блоков относительно друг друга)
# 3.1 Запустить игру "Жизнь" Как пример
# Общий вид таков:
#	ready: generate_ground(
#			diapason_gen(width,height),
#			resurse_gen(resurse),
#			form_gen([wave,life,recursive,fractal])
#		)
# В глобальную функцию указываем диапазон, ресурсы и форму
# На основании этих данных происходит генерация
# -------
