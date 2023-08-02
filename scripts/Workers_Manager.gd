extends Node2D

var active_worker = "Worker1" # активный работник
var is_active_w = true # активен ли контроллер
var click_pos = Vector2() # позиция кликa
var is_move_end = true # переменная которая будет отмечать закончено ли передвижение
var room_y = 0

onready var mouse_click = $Mouse_Click # получаем объект который отвечает за принятие кликов
onready var worker = get_node("Workers/" + active_worker) # получаем работника
onready var tween = get_node("Workers/" + active_worker + "/Sprite/Tween") # получаем объект твин для дальнейшей анимации
onready var do_duration = 150 # динамическая(?) длительность чтобы не было резкой анимации
onready var rooms = get_node("../Rentgenn/Rooms").get_children() # массив комнат
onready var actual_room = rooms[worker.get_index()] # актуальная комната


func room_define():
	worker = get_node("Workers/" + active_worker) # обновляем переменную
	var dis = abs(rooms[0].position.y - rooms[1].position.y) / 2 # сохраняем примерное расстояние от цента комнаты до ее края
	for i in rooms: # цикл перебирающий все комнаты
		if abs(worker.position.y - i.position.y) <= dis: # проверка находится ли игрок в i комнате
			actual_room = i # обновляем актуальную комнату
			break # завершаем цикл
	
func left_or_right(pos, end): # проверяем какая нужна анимация
	if pos > end: # если игрок находится правее конечной точки
		worker.state_change("move_left") 
	elif pos < end: # если игрок находится левее конечной точки
		worker.state_change("move_right")

	
func move_worker():
	is_move_end = false # отмечаем что передвижение еще не закончено
	mouse_click.input_pickable = false # выключаем кнопку на время передвижения
	is_active_w = false # вырубаем контроллер игрока
	
	
	# двигаем рабочего к середине дерева
	tween.interpolate_property(worker, "position", # настраиваем твин для плавного перемещения
		worker.position, Vector2(0, worker.position.y), abs(worker.position.x) / do_duration)
	tween.start() # запускаем анимацию
	left_or_right(worker.position.x, 0) # меняем анимацию
	yield(tween, "tween_completed") # дожидаемся завершения анимации
	
	# поднимаем его вверх/вниз
	tween.interpolate_property(worker, "position",
		worker.position, Vector2(0, room_y), abs(worker.position.y - room_y) / do_duration)
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
	is_active_w = true # собственно говоря включаем контроллер
	is_move_end = true # обратно меняем ведь передвижение закончилось


func _on_Mouse_Click_input_event(_viewport, event, shape_idx):  # был ли щелчок и был ли он совершен в пределах комнаты
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		worker = get_node("Workers/" + active_worker) # обновляем переменную
		if rooms[shape_idx] != actual_room: # если кликнул не на ту комнату в которой находится
			click_pos = get_local_mouse_position() # получаем позицию щелчка
			actual_room = rooms[shape_idx] # обновляем активную комнату
			room_y = actual_room.position.y # получаем комнату на которую кликнул игрок, получаем ее позицию по у
			move_worker() # активируем движение



