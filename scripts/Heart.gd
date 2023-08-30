extends StaticBody2D

var is_born = true
onready var anim = $"Worker_Born/Anima"
onready var worker = preload("res://scenes/Worker.tscn")	
onready var workers = $"../../../../Workers_Manager/Workers"

func _ready():
	is_born = false
	yield(get_tree().create_timer(1.5), "timeout")
	anim.play("worker_happy_birthday")
	yield(anim, "animation_finished")
	owner.get_node("Workers_Manager/Workers/Worker1").visible = true
	anim.play("RESET")
	print("hepi_bezdey")
	is_born = true


func room_def(body):
	if body.is_in_group("Worker"):
		body.room_define(self)


func add_worker():
	is_born = false
	anim.play("worker_happy_birthday")
	yield(anim, "animation_finished")
	var w = worker.instance() 
	w.position = Vector2(0, 157)
	workers.add_child(w)
	anim.play("RESET")
	is_born = true
