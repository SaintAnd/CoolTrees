extends KinematicBody2D
# скрипт для передвижения рабочего и всяких штучек (свечение, выбор и отмена выбора,смена персика)


var speed = 200 # скорость рабочего
#var gravity = 150 # сила гравитации (но пока что рабочий никуда не падает, так что это пока бесполезно)
var state = "worker_idle" 	# сохраняем начальную анимацию рабочего
var selected = false	# переменная будет отвечать за то, выбран ли работник при помощи прямоугольного выделения
var room = StaticBody2D 	# тут будем хранить комнату в которой находится этот рабочий
var is_moving = false

onready var anim = $Sprite/Anim # аниматор рабочего
onready var glow = $Sprite/Glow 	# свет при помощи которого будет выделяться активный рабочий
onready var glow_tween = $Sprite/Glow/Tween 	# аниматор для плавного включения и отключения свечения
onready var manager = get_parent().get_parent()	# объект Worker_Manager имеющий необходимые для работы переменные и функции
onready var elevator = 566
onready var elevator_anim = $"../../../Seed/Rooms_Manager/Rooms/Heart_Room/Elevator/Elevat"



func _ready():
	anim.play("worker_idle") # проигрываем анимацию сразу после начала игры
#	yield(get_tree().create_timer(0.1), "timeout")


func room_define(body):
	elevator = body.get_child(2).global_position.y
	elevator_anim = body.get_child(2).get_child(0)


func glowing(alpha):	# функция свечения вызываемая по окнончанию таймера (по задумке, но пока функция через скрипт работает) 
	if alpha == 1: 	# если передано значение альфы 1
		glow_tween.interpolate_property(glow, "color", glow.color, Color(0.95, 0.65, 0.28, 0.5), 0.4)	# настраиваем
		glow_tween.start() 	# запускаем анимку
	else: 	# если передано значение 0
		glow_tween.interpolate_property(glow, "color", glow.color, Color(0.95, 0.65, 0.28, 0), 0.08)	# тоже настраиваем
		glow_tween.start() 	# тооже запускаем
		
		
func _physics_process(_delta):
	var velocity = Vector2() # определяем велосити
	if is_moving: # если челик должен бежать к точке
		velocity.x += manager.kuda*speed
		move_and_slide(velocity) # двигаем челика к точке каждый кадр
		if abs(position.x - manager.click_pos.x) <= 2.0: # доп условие если достиг точки (если расстояние между точкой и позицией рабочего меньше трех)
			velocity.x = 0
			is_moving = false
			
	if manager.active_worker == name and manager.is_active_w: # проверка на активность данного рабочего
#		if Input.is_action_pressed("Left"): 	# если нажато действие влево
#			velocity.x -= speed 	# вычитаем переменную скорости из велосити по х, ну то есть из силы толчка в моем понимании) 
#		if Input.is_action_pressed("Right"):
#			velocity.x += speed 	# ну а тут аналогично прибавляем чтобы рабочий вправо бежал

		# меняем состояния	
		if velocity.x < 0: 	# если значение велосити отрицательное (то есть работник влево двигается
			state_change("move_left")  	# включаем анимку движения влево
			glowing(0) 	# отключаем подсветку
		elif velocity.x > 0:
			state_change("move_right") 	# тут анологично
			glowing(0)
		else: 	# если рабочий не двигается
			state_change("worker_idle") 	# включаем анимацию бездействия
			glowing(1) 	# включаем подсветку

	else: 	# если данный рабочий не активен
		glowing(0) 	# вырубаем подсветку

#	velocity.y += gravity # создаем гравитацию
#	move_and_slide(velocity) # двигаем через велосити

	if manager.is_active_w: # если передвижение окончено
		if manager.active_worker != name: # и данный рабочий не активен
			state_change("worker_idle") # проигрываем анимацию
	
	
func state_change(new_state): # проигрываем анимацию
	if state != new_state: # если анимация новая
		state = new_state # обновляем текущую анимацию
		anim.play(state) # включаем анимацию
	
#func _on_ChangePlayer_pressed(): # переключение на персонажа по нажатию
#	manager.active_worker = name # меняем активного рабочего
#	glowing(1)

func select(): 	# функция вызываемая при выборе работника при помощи прямоугольного выделения
	selected = true 	# меняем значение переменной
	modulate = Color.aquamarine	# пока что смена цвета рабочего ведь со свечением я пока не разобралась
	
func deselect(): 	# отмена выбора рабочего
	selected = false
	modulate = Color.white 	# возращаем цвет на нормальный
	

