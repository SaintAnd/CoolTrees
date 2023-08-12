extends MenuButton

func _ready():
	get_popup().add_item("Build")
	get_popup().add_item("Refresh")
	get_popup().add_item("Settings")
	get_popup().add_item("Quit")
	
	
	get_popup().connect('id_pressed', self, '_on_item_pressed')



func _on_item_pressed(id):
	var item_name = get_popup().get_item_text(id)
	if item_name == 'Build':
		get_node('/root/Root/BuildMenu').visible = true
	elif item_name == 'Refresh':
		get_tree().change_scene('res://scenes/Root.tscn')
	elif item_name == 'Settings':
		get_node('/root/Root/Settings').visible = true
	elif item_name == 'Quit':
		get_tree().quit()






