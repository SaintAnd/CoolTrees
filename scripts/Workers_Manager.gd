extends Node2D

var click_pos = Vector2() # позиция клика
var needed_room = 0 # необходимая комната


func _process(delta):
	if Input.is_action_just_pressed("mouse_left_click"): # был ли щелчок и был ли он совершен в пределах дерева
		click_pos = get_local_mouse_position()
	pass 


func room_define(): # функция определения комнаты
	pass
	
