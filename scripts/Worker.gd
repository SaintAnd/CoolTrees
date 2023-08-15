extends KinematicBody2D

var speed = 200 # скорость игрока
var gravity = 150 # сила гравитации
var state = "worker_idle" 
var selected = false

onready var anim = $Sprite/Anim # определение аниматора
onready var glow = $Sprite/Glow 
onready var tween = $Sprite/Glow/Tween
onready var manager = get_parent().get_parent()
onready var elevator = 0.0
onready var elevator_anim = AnimationPlayer

func _ready():
	anim.play("worker_idle") # проигрываем анимацию сразу после начала игры

func select():
	selected = true
	modulate = Color.aquamarine
	
func deselect():
	selected = false
	modulate = Color.white

func room_define(body):
	if body.is_in_group("Room"):
		elevator = body.get_child(3).global_position.y
		elevator_anim = body.get_child(3).get_child(0)


func glowing(alpha):
	if alpha == 1: 
		tween.interpolate_property(glow, "color", glow.color, Color(0.95, 0.65, 0.28, 1), 0.4)
		tween.start()
	else:
		tween.interpolate_property(glow, "color", glow.color, Color(0.95, 0.65, 0.28, 0), 0.08)
		tween.start()
		
func _physics_process(_delta):
	var velocity = Vector2() # определяем велосити
	if manager.active_worker == name and manager.is_active_w: # проверка на активность данного рабочего
		if Input.is_action_pressed("Left"): 
			velocity.x -= speed
		if Input.is_action_pressed("Right"):
			velocity.x += speed
			
		if velocity.x < 0: # меняем состояния
			state_change("move_left")
			glowing(0)
		elif velocity.x > 0:
			state_change("move_right")
			glowing(0)
		else:
			state_change("worker_idle")
			glowing(1)
	else:
		glowing(0)
	
	velocity.y += gravity # создаем гравитацию
	
	move_and_slide(velocity) # двигаем через велосити
	
	if manager.is_active_w: # если передвижение окончено
		if manager.active_worker != name: # и данный рабочий не активен
			state_change("worker_idle") # проигрываем анимацию
		
	
func state_change(new_state): # проигрываем анимацию
	if state != new_state: # если анимация новая
		state = new_state # обновляем текущую анимацию
		anim.play(state) # включаем анимацию
	
	
func _on_ChangePlayer_pressed(): # переключение на персонажа по нажатию
	manager.active_worker = name # меняем активного рабочего
	glowing(1)
