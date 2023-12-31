extends Node2D
# этот скрипт отвечает за случайное перемещение светлячка в разные стороны
# висит сцене с таким же названием


onready var fly_anim = $Sprite/Anim1	# анимация полета светляка
onready var glow_anim = $Sprite/Light2D/Anim2	# анимация свечения светляка (мигание)
onready var timer = $Timer	# таймер для создания промежутков (задержки) между перемещениями
onready var tween = $Tween	# твин для анимации полета светляка
onready var poly = get_parent()	# получаем область, за которую светлячок не может залететь


func _ready():
	fly_anim.play("firefly")	# запускаем анимки полета
	glow_anim.play("fly_glow")	# и свечения
	
	
func fly():	# эта функия вызывается при помощи сигнала timeout() у таймера который висит на светляке
	randomize()	# обновляем рандом (ну короче чтобы все по красоте работало)
	
	# определяем точку куда прилетит светляк (прибавляем к позиции светляка отрезок в пределах от -500 до 500)
	# в общем получится что светляк будет отлетать к точке в радиусе до 500 пикселей вокруг него 
	var pos = position + Vector2(int(rand_range(-500, 500)), int(rand_range(-500, 500))) 
	# определяем точку куда прилетит светляк (прибавляем к позиции светляка отрезок в пределах от -500 до 500)
	# в общем получится что светляк будет отлетать к точке в радиусе до 500 пикселей вокруг него 
	
	
	if Geometry.is_point_in_polygon(pos, poly.polygon):	# проверяем находится ли эта точка в области перемещения
		# поворачиваем светляка в сторону в которую он летит
		# при отрицательном значении разности мы можем сказать что светляк находится левее точки, так же и наоборот
		if position.x - pos.x <= 0: scale.x = -scale.x	
		else: scale.x = +scale.x
		
		tween.interpolate_property(self, "position", position, pos, 1)	# настраиваем анимацию
		tween.start() 	# запускаем анимацию
		yield(tween, "tween_completed")	# и дожидаемся ее окончания
	else: fly() 	# если точка вне области перемещения мы снова запускаем функцию
	
	timer.wait_time = 2 + randi() % 5	# обновляем промежуток между перемещениями
