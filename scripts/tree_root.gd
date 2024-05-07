extends Node2D

var cur = load("res://A_musor/cur2.tres")

var a = Vector2()#начальная точка корня
var b = Vector2()#конечная точка корня
var c = Vector2()#пока не используется

var t = 0.0#расстояние между точкой А(0) и Б(1) для pathf
var f = 0.0#расстояние между точкой А(0) и Б(1) для pulsar
var i = 0# счетчик до смены направления смещения корня влево или вправо
var g = 0# счетчик до добавления в кривую точку
var g_scale = 3# чем больше это значение тем менее полиганальны корни
var count = 0#кол-во точек у roots

var flag1 = true# этот флаг нужен чтобы начальная точка появлялась только раз
var flag2 = false# этот флаг нужен чтобы определить нажал ли игрок в нужной точке
var flag3 = -1# отвечает за то что волны идут то слева то справа
var flag4 = false# идет ли движение


export var speed_of_pulsar = 0.001# переменная определяющая скорость движения пульсара и соответственно скорость сбора
export var speed_of_roots = 0.001# определяет как быстро растут корни
export var mine = 10
export var reserve = 1000
export var curve_begin = 0.5
export var curve_end = 0.2
export var grow = 0.00025
export var curve_range = 15.0
#переменные с узлами
onready var curve = $path.curve
onready var point = $path/pathf
onready var roots = $roots.curve
onready var look = $look_of_roots

# массив источников рессурсов до которых мы дотянулись
var res_arr = [] 

func _ready():
	speed_of_pulsar = 0.001# переменная определяющая скорость движения пульсара и соответственно скорость сбора
	speed_of_roots = 0.001# определяет как быстро растут корни
	mine = 10
	reserve = 1000
	curve_begin = 0.5
	curve_end = 0.2
	grow = 0.00025
	curve_range = 15.0
	
	a = Vector2()#начальная точка корня
	b = Vector2()#конечная точка корня
	c = Vector2()#пока не используется

	t = 0.0#расстояние между точкой А(0) и Б(1) для pathf
	f = 0.0#расстояние между точкой А(0) и Б(1) для pulsar
	i = 0
	count = 0#кол-во точек у roots

	flag1 = true# этот флаг нужен чтобы начальная точка появлялась только раз
	flag2 = false# этот флаг нужен чтобы определить нажал ли игрок в нужной точке
	flag3 = -1
	flag4 = false
	point.rotation = 0
	curve.clear_points()
	$roots.curve.clear_points()


func pulsar():#функция реализующая движение пульсара
	$roots/pulsar.unit_offset = 1 - f# я бы мог оставить только следующую строчку и тогда бы он шел с начала до конца, а так он движется наоборот
	f+=speed_of_pulsar
	if f > 1:
		f = 0

func math(a: int)->int:#эта функция нужна чтобы преобразовать обычные координаты в координаты Tilemap(а там все по сетке 16 на 16)
	var b = a % 16
	a = a - b
	a = a / 16

	return a

func check(vec: Vector2, count: int ):
	if count == 0:
		return true
	elif res_arr[count - 1].pos == vec:
		return false
	else:
		return true

func _process(_delta):
	if Input.is_action_just_pressed("button_left") and curve.get_point_count() < 2 and flag2:#проверяем условия для начала движения корня
		if flag1:#этот кусочек выполняется один раз
			#a = point.position
			curve.add_point(a)
			flag1 = false
			$look_of_roots.width_curve.add_point(Vector2(0,curve_begin))
			$look_of_roots.width_curve.add_point(Vector2(1,curve_end))
		cur = load("res://A_musor/cur2.tres")
		curve_range = 15.0
		b = get_local_mouse_position()# конечная точка корня - позиция мыши
		b.y -=672
		t = 0# убеждаемся что мы движемся сначала
		#добавляем точки
		curve.add_point(b)
		flag4 = true
		$path/pathf/Point.look_at(get_global_mouse_position())
	if b and flag4:# если мы нажали, то начинается движение
		point.position = curve.interpolate(0,t)
		$path/pathf/Point/Tip.position.y = cur.interpolate(i/100.0)*curve_range*flag3
		var pos_tip = $path/pathf/Point/Tip.global_position
		pos_tip.y -= 672
		
		g+=1
		if g == g_scale: # если счетчик сработал
			roots.add_point(pos_tip)
			look.add_point(pos_tip)
			g = 0
		
		i+=1
		if i == 100:
			i = 0
			flag3 *=-1
		$look_of_roots.width_curve.set_point_value(0,curve_begin)
		$look_of_roots.width_curve.set_point_value(1,curve_end)
		curve_begin += grow
		curve_end +=grow
		if t>0.5:
			curve_range = 15.0 * ((1-t)*2)
		
		if t>0.2:
			cur = load("res://A_musor/cur.tres")
		
	
	if !is_equal_approx(t,1) and b:#если мы в движении и не закончили
		t+=speed_of_roots
	elif curve.get_point_count() == 2:# если мы закончили движение и точек у path 2 то удаляем начальную
		curve.remove_point(0)
		flag4 = false
	pulsar()# сбор

# если пульсар наткнулся на руду
func _on_Puls_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var res = Res.new()# Res - это созданый мною класс описанный в resource.gd
	var vec = $roots/pulsar/Puls.global_position# преобразуем позицию пульсара в позицию в TileMap
	vec.x = math(int(vec.x))
	vec.y = math(int(vec.y)) # почему -8? в root узел tree_root смещен на на 672, а в tree_root узел Tilemap смещен на -560, 672 - 560 = 112 делим на 16 так как сетка у Тайлмап по 16 и получаем 7, почему тогда мы смещаем на 8? Да хер его знает, так лучше работает
	var vecv = vec
	if $TileMap.get_cellv(vecv) == 1 or $TileMap.get_cellv(vecv) == 3 and check(vecv,res_arr.size()):#если индекс тайлов равен индексу руды
		res.id = body_shape_index# заполняем поля класса
		res.pos = vecv
		res.full = reserve
		res_arr.append(res)# добавляем класс в массив
		count +=1# еще одна точка для узля roots
	for j in res_arr:# перебираем массив и собираем ресурсы у плиток которые добавлены в массив
		if j.id == body_shape_index:# если ресурсы есть - собираем 
			if j.full >= mine:
				j.full -= mine
		if j.full <= 0:
			$TileMap.set_cellv(j.pos,0)

func _on_Mouse_Click_mouse_entered():# МЫШЪ в пространстве
	flag2 = true

func _on_Mouse_Click_mouse_exited():# МЫШЪ ушла
	flag2 = false

