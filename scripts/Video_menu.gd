extends Control
# дальше не ебу что написано, я просто перемещала куски кода 

func show_and_hide(first, second):
	first.show()
	second.hide()
	
func _on_FullScreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_Borderless_toggled(button_pressed):
	OS.window_borderless = button_pressed
	


func _on_VSync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed
