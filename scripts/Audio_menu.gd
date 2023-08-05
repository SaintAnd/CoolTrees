extends Control

onready var settings  = get_node("../Common_menu") # сохраняем меню настроек
const MUSIC_BUS = "Music"
const FX_BUS = "SoundFX"

# дальше не ебу что написано, я просто перемещала куски кода 

func show_and_hide(first, second):
	first.show()
	second.hide()
	
func _on_Master_value_changed(value):
	if value == -45:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
	AudioServer.set_bus_volume_db(0,value)

	
func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)


func _on_Music_value_changed(value):
	var BusInt = AudioServer.get_bus_index(MUSIC_BUS)
	AudioServer.set_bus_volume_db(BusInt, value)


func _on_SoundFX_value_changed(value):
	var BusInt = AudioServer.get_bus_index(FX_BUS)
	AudioServer.set_bus_volume_db(BusInt, value)


func _on_BackFromAudio_pressed():
	show_and_hide(settings, self)
