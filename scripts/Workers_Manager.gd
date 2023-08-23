extends Node2D
# скрипт который отвечает за действия связанные с рабочими


var active_worker = "Worker1" # активный работник
var is_active_w = true # активен ли контроллер
var click_pos = Vector2() # позиция кликa
var room_y = 0
var workk = []

onready var mouse_click = $Mouse_Click # получаем объект который отвечает за принятие кликов
onready var worker = get_node("Workers/" + active_worker) # получаем работника
onready var tween = get_node("Workers/" + active_worker + "/Sprite/Tween") # получаем объект твин для дальнейшей анимации
onready var do_duration = 150 # динамическая(?) длительность чтобы не было резкой анимации
onready var rooms = get_node("../Rentgenn/Rooms").get_children() # массив комнат
onready var actual_room = rooms[worker.get_index()] # актуальная комната
onready var workers = $Workers



func room_define(worke): 	# функция определяющая комнату
	var dis = abs(rooms[0].position.y - rooms[1].position.y) / 2 # сохраняем примерное расстояние от цента комнаты до ее края
	for i in rooms: # цикл перебирающий все комнаты
		if abs(worke.position.y - i.position.y) <= dis: # проверка находится ли игрок в i комнате
			actual_room = i # обновляем актуальную комнату
			worke.room = i
			break # завершаем цикл
	
	
func left_or_right(pos, end): # проверяем какая нужна анимация
	if pos > end: # если игрок находится правее конечной точки
		worker.state_change("move_left") 
	elif pos < end: # если игрок находится левее конечной точки
		worker.state_change("move_right")


func move_inside(worke): 	# передвижение внутри комнаты
	room_define(worke) 	# определяем комнатку
	mouse_click.input_pickable = false # выключаем кнопку на время передвижения
	is_active_w = false # вырубаем контроллер игрока

	# двигаем по горизонтали до необходимой точки
	tween.interpolate_property(worke, "position", 	# настраиваем анимку движения
		worke.position, Vector2(click_pos.x, worke.position.y), abs(click_pos.x - worke.position.x) / do_duration)
	tween.start()
	left_or_right(worke.position.x, click_pos.x)
	yield(tween, "tween_completed")
	
	mouse_click.input_pickable = true # включаем обратно чтобы игрок мог дальше гулять
	is_active_w = true # собственно говоря включаем контроллер
	
	
	
func move_into_room(worke): 	# передвижение между комнатами
	room_define(worke) 	# опять определяем комнату
	mouse_click.input_pickable = false # выключаем кнопку на время передвижения
	is_active_w = false # вырубаем контроллер игрока
	
	
	# двигаем рабочего к середине дерева
	tween.interpolate_property(worke, "position", # настраиваем твин для плавного перемещения
		worke.position, Vector2(0, worke.position.y), abs(worke.position.x) / do_duration)
	tween.start() # запускаем анимацию
	left_or_right(worke.position.x, 0) # меняем анимацию
	yield(tween, "tween_completed") # дожидаемся завершения анимации
	
	# поднимаем его вверх/вниз
	tween.interpolate_property(worke, "position",
		worke.position, Vector2(0, room_y), abs(worke.position.y - room_y) / do_duration)
	tween.start()
	worke.state_change("worker_climb") 
	yield(tween, "tween_completed")
	worke.state_change("worker_idle") # меняем анимацию
	yield(get_tree().create_timer(0.5), "timeout") # дожидаемся приземления рабочего на землю
	
	# двигаем по горизонтали до необходимой точки
	tween.interpolate_property(worke, "position",
		worke.position, Vector2(click_pos.x, worke.position.y), abs(click_pos.x) / do_duration)
	tween.start()
	left_or_right(worke.position.x, click_pos.x)
	yield(tween, "tween_completed")
	
	
	mouse_click.input_pickable = true # включаем обратно чтобы игрок мог дальше гулять
	is_active_w = true # собственно говоря включаем контроллер


# тут пока нету комментов потому что я еще доделываю эту часть
func _on_Mouse_Click_input_event(_viewport, event, shape_idx):  # был ли щелчок и был ли он совершен в пределах комнаты
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		workers = $Workers
		click_pos = get_local_mouse_position() # получаем позицию щелчка
		worker = get_node("Workers/" + active_worker) # обновляем переменную
		if workk == []:
			if rooms[shape_idx] != actual_room: # если кликнул не на ту комнату в которой находится
				actual_room = rooms[shape_idx] 
				room_y = actual_room.position.y
				move_into_room(worker) # активируем движение
			else:
				actual_room = rooms[shape_idx] 
				room_y = actual_room.position.y
				move_inside(worker)
		else:
			is_active_w = false
			actual_room = rooms[shape_idx] 
			room_y = actual_room.position.y
			for item in workk:
				if item.room != rooms[shape_idx]:
					move_into_room(item)
					yield(tween, "tween_all_completed")
				else:
					move_inside(item)
					yield(tween, "tween_all_completed")
			active_worker = workk[0].name
			workk = []



