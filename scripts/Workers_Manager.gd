extends Node2D

var click_pos = Vector2() # позиция кликa
var is_move_end = true # переменная которая будет отмечать закончено ли передвижение

onready var mouse_click = get_node("../Mouse_Click") # получаем объект который отвечает за принятие кликов
onready var worker = get_node(str(owner.active_player)) # получаем работника
onready var tween = get_node(worker.name + "/Sprite/Tween") # получаем объект твин для дальнейшей анимации
onready var do_duration = 150 # динамическая(?) длительность чтобы не было резкой анимации


func left_or_right(pos, end): # проверяем какая нужна анимация
	if pos > end: # если игрок находится правее конечной точки
		worker.state_change("move_left") 
	elif pos < end: # если игрок находится левее конечной точки
		worker.state_change("move_right")

	
func move_worker():
	is_move_end = false # отмечаем что передвижение еще не закончено
	worker = get_node(str(owner.active_player)) # обновляем переменную
	mouse_click.input_pickable = false # выключаем кнопку на время передвижения
	owner.is_active_p = false # вырубаем контроллер игрока
	
	
	# двигаем рабочего к середине дерева
	tween.interpolate_property(worker, "position", # настраиваем твин для плавного перемещения
		worker.position, Vector2(0, worker.position.y), abs(worker.position.x) / do_duration)
	tween.start() # запускаем анимацию
	left_or_right(worker.position.x, 0) # меняем анимацию
	yield(tween, "tween_completed") # дожидаемся завершения анимации
	
	# поднимаем его вверх/вниз
	tween.interpolate_property(worker, "position",
		worker.position, Vector2(worker.position.x, click_pos.y), abs(worker.position.y - click_pos.y) / do_duration)
	tween.start()
	worker.state_change("worker_climb") 
	yield(tween, "tween_completed")
	worker.state_change("worker_idle") # меняем анимацию
	yield(get_tree().create_timer(0.5), "timeout") # дожидаемся приземления рабочего на землю
	
	# двигаем по горизонтали до необходимой точки
	tween.interpolate_property(worker, "position",
		worker.position, Vector2(click_pos.x, worker.position.y), abs(click_pos.x) / do_duration)
	tween.start()
	left_or_right(worker.position.x, click_pos.x)
	yield(tween, "tween_completed")
	
	
	mouse_click.input_pickable = true # включаем обратно чтобы игрок мог дальше гулять
	owner.is_active_p = true # собственно говоря включаем контроллер
	is_move_end = true # обратно меняем ведь передвижение закончилось


func _on_Mouse_Click_input_event(_viewport, event, _shape_idx):  # был ли щелчок и был ли он совершен в пределах комнаты
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		click_pos = get_local_mouse_position() # получаем позицию щелчка
		move_worker() # активируем движение
