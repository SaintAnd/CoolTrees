extends Node2D


var a = Vector2()#начальная точка корня
var b = Vector2()#конечная точка корня
var c = Vector2()
var t = 0.0
var f = 0.0
var count = 0
var flag1 = true
var flag2 = false
onready var curve = $path.curve
onready var point = $path/pathf
onready var tip = $path/pathf/tip
onready var roots = $roots.curve
onready var look = $look_of_roots

func _process(delta):
	if Input.is_action_just_pressed("button_left") and curve.get_point_count() < 2:
		if flag1:
			a = point.position
			curve.add_point(a)
			roots.add_point(a)
			look.add_point(a)
			flag1 = false
		b = get_local_mouse_position()
		flag2 = true
		t = 0
		count +=1
		curve.add_point(b)
		roots.add_point(b)
		look.add_point(a)
	if b:
		point.position = curve.interpolate(0,t)
		
		look.set_point_position(count,point.position)
	
	if !is_equal_approx(t,1) and b:
		t+=0.01
	elif curve.get_point_count() == 2:
		curve.remove_point(0)
		flag2 = false
	
	#$roots/pulsar.unit_offset = 1 - t 
	#if flag2:
	#	f+=0.1
	#	tip.look_at(b)
	#	c.y = sin(f) * 2
	#	tip.translate(c)
