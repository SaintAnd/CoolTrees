extends KinematicBody2D

var speed = 200

var state = "worker_idle" setget state_change
onready var sprite = $Sprite
onready var anim = $Sprite/Anim
onready var nature = get_node("../../../Node2D/Nature")

func _ready():
	anim.play("worker_idle")
	
	
func _physics_process(delta):
	if owner.active_player == name:
		var velocity = Vector2()
		
		if Input.is_action_pressed("Left"):
			velocity.x -= speed
		if Input.is_action_pressed("Right"):
			velocity.x += speed
			
		move_and_slide(velocity)
		
		if velocity.x < 0:
			state_change("move_left")
		elif velocity.x > 0:
			state_change("move_right")
		else:
			state_change("worker_idle")

func state_change(new_state):
	if state != new_state:
		state = new_state
		anim.play(state)
	
	
func _on_ChangePlayer_pressed():
	owner.active_player = name
	nature.move_to_player(self.position)
