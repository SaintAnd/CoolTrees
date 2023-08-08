extends Node2D


var a = Vector2()#начальная точка корня
var b = Vector2()#конечная точка корня
var c = Vector2()#пока не используется
var t = 0.0#расстояние между точкой А(0) и Б(1) для pathf
var f = 0.0#расстояние между точкой А(0) и Б(1) для pulsar
var count = 0#кол-во точек у roots
var flag1 = true# этот флаг нужен чтобы начальная точка появлялась только раз
var flag2 = false# этот флаг нужен чтобы определить нажал ли игрок в нужной точке

export var speed_of_pulsar = 0.01# переменная определяющая скорость движения пульсара и соответственно скорость сбора
export var speed_of_roots = 0.01# определяет как быстро растут корни

#переменные с узлами
onready var curve = $path.curve
onready var point = $path/pathf
onready var roots = $roots.curve
onready var look = $look_of_roots

# массив источников рессурсов до которых мы дотянулись
var res_arr = [] 

func pulsar():#функция реализующая движение пульсара
	$roots/pulsar.unit_offset = 1 - f# я бы мог оставить только следующую строчку и тогда бы он шел с начала до конца, а так он движется наоборот
	f+=speed_of_pulsar 

func math(a: int)->int:#эта функция нужна чтобы преобразовать обычные координаты в координаты Tilemap(а там все по сетке 16 на 16)
	var b = a % 16
	a = (a - b) / 16
	a = int(a)
	return a

func check(vec: Vector2, count: int ):
	if count == 0:
		return true
	if res_arr[count - 1].pos == vec:
		return false
	else:
		return true

func _process(delta):
	if Input.is_action_just_pressed("button_left") and curve.get_point_count() < 2 and flag2:#проверяем условия для начала движения корня
		if flag1:#этот кусочек выполняется один раз
			a = point.position
			curve.add_point(a)
			roots.add_point(a)
			look.add_point(a)
			flag1 = false
		b = get_local_mouse_position()# конечная точка корня - позиция мыши
		#$path/pathf/Mouse_Click/CollisionPolygon2D.look_at(b + $path/pathf/Mouse_Click/CollisionPolygon2D.global_position)
		t = 0# убеждаемся что мы движемся сначала
		count +=1# еще одна точка для узля roots
		#добавляем точки
		curve.add_point(b)
		roots.add_point(b)
		look.add_point(a)
	if b:# если мы нажали, то начинается движение
		point.position = curve.interpolate(0,t)
		look.set_point_position(count,point.position)#кончик отрисовывающего узла движется 
	
	if !is_equal_approx(t,1) and b:#если мы в движении и не закончили
		t+=speed_of_roots
	elif curve.get_point_count() == 2:# если мы закончили движение и точек у path 2 то удаляем начальную
		curve.remove_point(0)
	pulsar()# сбор

# если пульсар наткнулся на руду
func _on_Puls_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var res = Res.new()# Res - это созданый мною класс описанный в resource.gd
	
	var vec = $roots/pulsar/Puls.global_position# преобразуем позицию пульсара в позицию в TileMap
	vec.x = math(int(vec.x))
	vec.y = math(int(vec.y)) - 8
	
	if $TileMap.get_cellv(vec) == 1 or $TileMap.get_cellv(vec) == 3 and check(vec,res_arr.size()):#если индекс тайлов равен индексу руды
		
		res.id = body_shape_index# заполняем поля класса
		res.pos = vec
		res_arr.append(res)# добавляем класс в массив
	for i in res_arr:# перебираем массив и собираем ресурсы у плиток которые добавлены в массив
		if i.id == body_shape_index:# если ресурсы есть - собираем 
			if i.full >= 100:
				i.full -= 100
			else:# если нет меняем плитку на истощившуюся
				$TileMap.set_cellv(vec,0)
	

func _on_Mouse_Click_mouse_entered():# МЫШЪ в пространстве
	flag2 = true

func _on_Mouse_Click_mouse_exited():# МЫШЪ ушла
	flag2 = false
