extends Node2D

var a = Vector2()#начальная точка корня
var b = Vector2()#конечная точка корня
var c = Vector2()#точка отклонения(к ней корень отклоняется на пути между начальной и конечной точкой)
var s = Vector2(-1,1)#этот вектор нужен для создания точки отклонения
var con#длина вектора соеденяющего вектора a и b
var t = 0.15#скорость интерполяции из точки a в точку b
var flag = -1#этот флаг отвечает за то чтобы точка отклонения была то слева то справа

func interpolate(p0:Vector2,p1:Vector2,p2:Vector2,t):
	var q0 = p0.linear_interpolate(p1,t)# функция спизжена отсюда https://docs.godotengine.org/ru/stable/tutorials/math/beziers_and_curves.html
	var q1 = p1.linear_interpolate(p2,t)
	var r = q0.linear_interpolate(q1,t)
	return r

func _process(delta):
	a = $tip.position
	if Input.is_action_just_pressed("mouse_left_click"):#конечная точка задается когда игрок нажал левой кнопкой мыши
		b = get_local_mouse_position()#конечной точкой является место куда кликнул игрок
		flag *= -1#попеременно меняем флаг на левый и правый
		
	if b:#если вектор b инициализирован
		c = b - a#задаем вектору с вектор соеденяющий a и b
		con = (sqrt(c.x * c.x + c.y * c.y))/2#узнаем длину вектора c, вот и Теорема Пифагора пригодилась:>
		c.x /=2#сокращаем вектор в два раза и находим середину
		c.y /=2
		c = c + (s * con/2 * flag) #смещаем относительно вектора соеденяющего a и b
		c = c + a
		
		$tip.position = interpolate(a,c,b,t)
		


