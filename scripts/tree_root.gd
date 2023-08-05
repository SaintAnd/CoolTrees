extends Node2D


var a = Vector2()#начальная точка корня
var b = Vector2()#конечная точка корня
var c = Vector2()
var t = 0.0
var f = 0.0
var count = 0
var flag1 = true
var flag2 = false
var speed_of_pulsar = 0.01
onready var curve = $path.curve
onready var point = $path/pathf
onready var tip = $path/pathf/tip
onready var roots = $roots.curve
onready var look = $look_of_roots

var res_arr = [] 

func pulsar():
	$roots/pulsar.unit_offset = 1 - f
	f+=speed_of_pulsar 

func math(a: int)->int:
	var b = a % 16
	a = (a - b) / 16
	a = int(a)
	return a


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
	pulsar()

func _on_Puls_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var res = Res.new()
	var vec = $roots/pulsar/Puls.global_position
	vec.x = math(int(vec.x))
	vec.y = math(int(vec.y)) - 8
	if $TileMap.get_cellv(vec) == 1 or $TileMap.get_cellv(vec) == 3:
		res.id = body_shape_index
		res.pos = vec
		res_arr.append(res)
	for i in res_arr:
		if i.id == body_shape_index:
			if i.full >= 100:
				i.full -= 100
			else:
				$TileMap.set_cellv(vec,0)
	print("hi")
		



