extends Node2D
var cur = load("res://A_musor/cur.tres")
var t= 0.0
onready var s = $Node2D/Sprite
var a = Vector2(0.01,0)
var flag = false
func _process(delta):
	if flag:
		a.y = sin(s.position.x) * 100
		s.translate(a)

func _draw():
	for i in 20:
		#draw_circle(Vector2(100+i*10, 200 - cur.interpolate(i/20.0)*100.0),
		#5,Color.greenyellow)
		draw_circle(Vector2(100+i*10, cur.interpolate(i/20.0)*100.0),
		5,Color.greenyellow)
