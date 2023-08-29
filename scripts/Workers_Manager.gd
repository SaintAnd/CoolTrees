extends Node2D
# скрипт который отвечает за действия связанные с рабочими


var active_worker = "Worker1" # активный работник
var is_active_w = true # активен ли контроллер
var click_pos = Vector2() # позиция кликa
var workk = []
var click_active = true

#onready var mouse_click = $Mouse_Click # получаем объект который отвечает за принятие кликов
onready var worker = get_node("Workers/" + active_worker) # получаем работника
onready var tween = get_node("Workers/" + active_worker + "/Sprite/Tween") # получаем объект твин для дальнейшей анимации
onready var do_duration = 150 # динамическая(?) длительность чтобы не было резкой анимации
onready var rooms_manager = $"../Seed/Rooms_Manager" # менеджер комнат
onready var rooms = rooms_manager.get_node("Rooms").get_children() # массив комнат
onready var actual_room = rooms[worker.get_index()] # актуальная комната
onready var workers = $Workers
onready var heart_room = rooms[len(rooms)-1]
	

func _ready():
	worker.elevator = heart_room.get_child(2).global_position.y
	worker.elevator_anim = heart_room.get_child(2).get_child(0)


func left_or_right(pos, end): # проверяем какая нужна анимация
	if pos > end: # если игрок находится правее конечной точки
		worker.state_change("move_left") 
	elif pos < end: # если игрок находится левее конечной точки
		worker.state_change("move_right")


func move_inside(worke, elev): # передвижение внутри комнаты
	click_active = false # выключаем кнопку на время передвижения
	is_active_w = false # вырубаем контроллер игрока

	# двигаем по горизонтали до необходимой точки
	tween.interpolate_property(worke, "position", 	# настраиваем анимку движения
		worke.position, Vector2(click_pos.x, worke.position.y), abs(click_pos.x - worke.position.x) / do_duration)
	tween.start()
	left_or_right(worke.position.x, click_pos.x)
	yield(tween, "tween_completed")
	
	worke.elevator = elev.global_position.y
	worke.elevator_anim = elev.get_child(0)
	
	
	click_active = true # включаем обратно чтобы игрок мог дальше гулять
	is_active_w = true # собственно говоря включаем контроллер
	
	
	
func move_into_room(worke, elev): 	# передвижение между комнатами
	click_active = false # выключаем кнопку на время передвижения
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
	worke.anim.play("in_elevator")
	yield(worke.anim, "animation_finished")
	worke.z_index = 0
	worke.elevator_anim.play("elev_close")
	yield(worke.elevator_anim, "animation_finished")
	
	worke.elevator = elev.global_position.y
	worke.elevator_anim = elev.get_child(0)
	
	# поднимаем его вверх/вниз
	worke.global_position = Vector2(0, worke.elevator-1)
	yield(get_tree().create_timer(2.0), "timeout")
	worke.elevator_anim.play("elev_open")
	yield(worke.elevator_anim, "animation_finished")
	worke.z_index = 1
	worke.elevator_anim.play("elev_close")
	worke.anim.play("out_elevator")
	yield(worke.anim, "animation_finished")
	worke.anim.play("worker_idle")
	
	
#	print(worke.elevator)
#	print(elev)

	click_active = true # включаем обратно чтобы игрок мог дальше гулять
	is_active_w = true # собственно говоря включаем контроллер


func click_event(event, shape_idx):  # был ли щелчок и был ли он совершен в пределах комнаты
	var elevat = rooms_manager.elevators[shape_idx] # лифт из которого должен выйти рабочий
	click_pos = get_local_mouse_position() # получаем позицию щелчка
	worker = get_node("Workers/" + active_worker) # обновляем переменную
	if workk == []: # если массив выбранных челиков пустой (ни один рабочий не выбран)
#		print(worker.elevator)
#		print(elevat)
		if worker.elevator != elevat.global_position.y: # если кликнул не на ту комнату в которой находится
			move_into_room(worker, elevat) # активируем движение
		else:
			if heart_room.is_born == true:
				move_inside(worker, elevat)
	else:
		is_active_w = false
		for item in workk:
			if item.elevator != elevat.global_position.y:
				move_into_room(item, elevat)
				yield(tween, "tween_all_completed")
			else:
				move_inside(item, elevat)
				yield(tween, "tween_all_completed")
		active_worker = workk[0].name
		workk = []




