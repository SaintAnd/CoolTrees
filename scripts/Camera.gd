class_name ZoomingCamera2D
extends Camera2D

# Задаём переменной путь до ренгена желудя.
onready var imageVerx = get_node("/root/Root/Environment/Seed/Verx")




#Отвечает за блокировку камеры и блокировку приближения на Enter
onready var start = true # Включил переменную на true чтобы не нажимать Enter
# Минимальное значение для зума `_zoom_level`.
export var min_zoom := 0.5
# Максимальное значение для зума `_zoom_level`.
export var max_zoom := 2.0
# Контролирует, насколько мы увеличиваем или уменьшаем `_zoom_level` при каждом прокручивание колесика мыши.
export var zoom_factor := 0.1
# Продолжительность анимации движения зума.
export var zoom_duration := 0.2

# Целевой уровень масштабирования камеры.
var _zoom_level := 1.0 setget _set_zoom_level

# Присваиваем переменной tween узел анимации $Tween
onready var tween: Tween = $Tween



func _set_zoom_level(value: float) -> void:
	# Задаём лимит значений между `min_zoom` и `max_zoom`
	_zoom_level = clamp(value, min_zoom, max_zoom)

	
	# Делаем плавную анимацию.	
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		tween.EASE_OUT
	)
	tween.start()
	
	

func _unhandled_input(event):
	# Задаём условие для запрета приближения камеры до нажатия на ENTER
	if start == true:
		# Приближение камеры
		if event.is_action_pressed("zoom_in"):
			# Внутри данного класса нам нужно либо написать `self._zoom_level = ...` или точно
			# вызвать функцию установки, чтобы использовать ее.
			_set_zoom_level(_zoom_level - zoom_factor)
		# Отдаление камеры
		if event.is_action_pressed("zoom_out"):
			_set_zoom_level(_zoom_level + zoom_factor)
		
		# Задаём значение переменной Start, чтобы после нажатия на ENTER зум вновь заработал
	#if start == false and event.is_action_pressed("Enter"):
func _ready():
	if start == true:
		_set_zoom_level(_zoom_level - zoom_factor)
		
		
		start = true # Задаём значение true, чтобы условия приближения на колесико начинали работать
		zoom_duration = 1.25 # Плавность приближения
		
		

		# Анимация
		tween.interpolate_property(
			self,
			"zoom",
			zoom,
			Vector2(0.8, 0.8),
			zoom_duration,
			tween.TRANS_SINE,
			tween.EASE_OUT
		)
		tween.start()
	
	# Сетку не видно, когда приближение на 1-е	
	if _zoom_level > 1:
		imageVerx.visible = true
	# Сетку видно, когда приближение меньше 1-ы
	elif _zoom_level < 1:
		imageVerx.visible = false













