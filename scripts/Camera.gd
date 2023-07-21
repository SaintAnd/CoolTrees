extends Camera2D

onready var zoomfactor = 1 # На сколько далеко отдаляется камера
onready var zoomspeed = 20 # Скорость отдаления
onready var zoomstep = 0.03 # Шаг приближения
onready var factorstep = 0.01 # Скорость прекращения приближения

func _ready():
	pass

func _process(delta):
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)
	
	zoom.x = clamp(zoom.x, 0.5,2)
	zoom.y = clamp(zoom.y, 0.5,2)
	
	if zoomfactor > 1:
		zoomfactor -= zoomstep
	elif zoomfactor < 1:
		zoomfactor += zoomstep
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoomfactor -= zoomstep
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoomfactor = zoomstep
