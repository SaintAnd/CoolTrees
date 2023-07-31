extends CanvasLayer

onready var com_menu = $Common_menu # меню настроек
onready var video = $Video_menu # меню видео
onready var audio = $Audio_menu # меню аудио

	
func show_and_hide(first, second):
	first.hide()
	second.show()
	
func _on_Video_pressed(): # если нажата кнопка видео
	show_and_hide(com_menu, video) # открываем меню видео


func _on_Audio_pressed(): # если нажата кнопка аудио
	show_and_hide(com_menu, audio) # открываем меню аудио


func _on_BackFromSettings_pressed(): # если нажата кнопка назад
	self.hide() # прячем меню настроек

