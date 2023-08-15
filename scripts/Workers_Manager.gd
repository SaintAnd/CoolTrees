extends Node2D

var active_worker = "Worker1" # активный работник
var is_active_w = true # активен ли контроллер
var click_pos = Vector2() # позиция кликa
var workk = []

onready var mouse_click = $Mouse_Click # получаем объект который отвечает за принятие кликов
onready var worker = get_node("Workers/" + active_worker) # получаем работника
onready var tween = get_node("Workers/" + active_worker + "/Sprite/Tween") # получаем объект твин для дальнейшей анимации
onready var do_duration = 150 # динамическая(?) длительность чтобы не было резкой анимации
onready var rooms_manager = $"../Rentgenn/Rooms" # массив комнат
onready var rooms = rooms_manager.get_children() # массив комнат
onready var actual_elev = rooms[worker.get_index()].get_child(3) # актуальная комната
onready var workers = $Workers
	

func _ready():
	worker.elevator = actual_elev.global_position.y
	worker.elevator_anim = actual_elev.get_child(0)

func left_or_right(pos, end): # проверяем какая нужна анимация
	if pos > end: # если игрок находится правее конечной точки
		worker.state_change("move_left") 
	elif pos < end: # если игрок находится левее конечной точки
		worker.state_change("move_right")


func move_inside(worke):
	mouse_click.input_pickable = false # выключаем кнопку на время передвижения
	is_active_w = false # вырубаем контроллер игрока

	# двигаем по горизонтали до необходимой точки
	tween.interpolate_property(worke, "position",
		worke.position, Vector2(click_pos.x, worke.position.y), abs(click_pos.x - worke.position.x) / do_duration)
	tween.start()
	left_or_right(worke.position.x, click_pos.x)
	yield(tween, "tween_completed")
	
	mouse_click.input_pickable = true # включаем обратно чтобы игрок мог дальше гулять
	is_active_w = true # собственно говоря включаем контроллер
	
	
	
func move_into_room(worke):
	mouse_click.input_pickable = false # выключаем кнопку на время передвижения
	is_active_w = false # вырубаем контроллер игрока
	
	
	# двигаем рабочего к середине дерева
	tween.interpolate_property(worke, "position", # настраиваем твин для плавного перемещения
		worke.position, Vector2(0, worke.position.y), abs(worke.position.x) / do_duration)
	tween.start() # запускаем анимацию
	left_or_right(worke.position.x, 0) # меняем анимацию
	yield(tween, "tween_completed") # дожидаемся завершения анимации
	worke.state_change("worker_idle") 
	worke.elevator_anim.play("elev_open")
	yield(worke.elevator_anim, "animation_finished")
	worke.z_index = 0
	worke.elevator_anim.play("elev_close")
	yield(worke.elevator_anim, "animation_finished")
	worke.modulate.a = 0
	
	# поднимаем его вверх/вниз
	worke.position = Vector2(0, worke.elevator)
	print(worke.elevator)
	yield(tween, "tween_completed")
	worke.elevator_anim.play("elev_open")
	yield(worke.elevator_anim, "animation_finished")
	worke.z_index = 1
	worke.elevator_anim.play("elev_close")
	yield(worke.elevator_anim, "animation_finished")
	worke.modulate.a = 1
	
#	# двигаем по горизонтали до необходимой точки
#	tween.interpolate_property(worke, "position",
#		worke.position, Vector2(click_pos.x, worke.position.y), abs(click_pos.x) / do_duration)
#	tween.start()
#	left_or_right(worke.position.x, click_pos.x)
#	yield(tween, "tween_completed")
	
	
	mouse_click.input_pickable = true # включаем обратно чтобы игрок мог дальше гулять
	is_active_w = true # собственно говоря включаем контроллер


func _on_Mouse_Click_input_event(_viewport, event, shape_idx):  # был ли щелчок и был ли он совершен в пределах комнаты
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		var elevat = rooms_manager.elevators[shape_idx]
		click_pos = get_local_mouse_position() # получаем позицию щелчка
		worker = get_node("Workers/" + active_worker) # обновляем переменную
		if workk == []:
			if rooms[shape_idx].get_child(3) != actual_elev: # если кликнул не на ту комнату в которой находится
				actual_elev = rooms[shape_idx].get_child(3)
				move_into_room(worker) # активируем движение
			else:
				actual_elev = rooms[shape_idx].get_child(3)
				move_inside(worker)
		else:
			is_active_w = false
			actual_elev = rooms[shape_idx].get_child(3)
			for item in workk:
				if item.elevator != elevat:
					move_into_room(item)
					yield(tween, "tween_all_completed")
				else:
					move_inside(item)
					yield(tween, "tween_all_completed")
			active_worker = workk[0].name
			workk = []




