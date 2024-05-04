extends MenuButton

var ref = load('res://scripts/tree_root.gd')

#Добавляем варианты
func _ready():
	get_popup().add_item("Строительство")
	get_popup().add_item("Перезапуск")
	get_popup().add_item("Настройки")
	get_popup().add_item("Выйти в меню")
	get_popup().add_item("Выйти на рабочий стол")
	get_popup().connect('id_pressed', self, '_on_item_pressed')


#Проверяем какая кнопка нажата
func _on_item_pressed(id):
	var item_name = get_popup().get_item_text(id)
	
	if item_name == 'Строительство':
		get_node('/root/Root/BuildMenu').visible = true
		
	elif item_name == 'Перезапуск':
		get_tree().change_scene('res://scenes/Root.tscn')
		get_node('/root/Root/tree_root').set_script(ref)
		#get_tree().reload_current_scene()

		
	elif item_name == 'Настройки':
		get_node('/root/Root/Settings').visible = true
		
	elif item_name == 'Выйти в меню':
		get_tree().change_scene('res://scenes/Main_menu.tscn')
		
	elif item_name == 'Выйти на рабочий стол':
		get_tree().quit()






