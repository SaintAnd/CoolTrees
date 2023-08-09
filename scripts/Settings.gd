extends CanvasLayer

onready var com_menu = $Common_menu # меню настроек
onready var video = $Video_menu # меню видео
onready var audio = $Audio_menu # меню аудио

	
func show_and_hide(first, second):
	first.hide()
	second.show()
	

func _on_BackFromSettings_pressed(): # если нажата кнопка назад
	$ButtonClickSound.play()
	self.hide() # прячем меню настроек


func _on_TabSettings_tab_changed(tab):
	$ButtonClickSound.play()
	pass # Replace with function body.
