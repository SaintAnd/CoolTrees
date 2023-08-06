extends Control

onready var menu = $Menu
onready var settings = $Settings


func show_and_hide(first, second):
	first.show()
	second.hide()
	
	
func _process(_delta):
	if Input.is_action_just_pressed('ui_cancel'):
		toggle()
		
		
func toggle():
	visible = !visible
	get_tree().paused = visible
	
	
func _on_Start_pressed():
	toggle()
	get_tree().change_scene('res://scenes/Root.tscn')


func _on_Settings2_pressed():
	settings.show()

	
func _on_Quit_pressed():
	get_tree().quit()
