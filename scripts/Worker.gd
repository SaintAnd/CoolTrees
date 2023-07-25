extends KinematicBody2D

var speed = 200 # скорость игрока
var gravity = 150 # сила гравитации

var state = "worker_idle" 
onready var anim = $Sprite/Anim # определение аниматора

func _ready():
	anim.play("worker_idle") # проигрываем анимацию сразу после начала игры
	
	
func _physics_process(delta):
	var velocity = Vector2() # определяем велосити
	if owner.active_player == name and owner.is_active_p: # проверка на активность данного рабочего
		if Input.is_action_pressed("Left"): 
			velocity.x -= speed
		if Input.is_action_pressed("Right"):
			velocity.x += speed
			
		if velocity.x < 0: # меняем состояния
			state_change("move_left")
		elif velocity.x > 0:
			state_change("move_right")
		else:
			state_change("worker_idle")
	
	velocity.y += gravity # создаем гравитацию
	
	move_and_slide(velocity) # двигаем через велосити
	
	if owner.active_player != name and get_parent().is_move_end: # если данный рабочий не активен и передвижение окончено
		state_change("worker_idle") # проигрываем анимацию
		
	
func state_change(new_state): # проигрываем анимацию
	if state != new_state: # если анимация новая
		state = new_state
		anim.play(state) 
	
	
func _on_ChangePlayer_pressed(): # переключение на персонажа по нажатию
	owner.active_player = name