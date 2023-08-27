extends Node2D

#Первый запуск сцены
func _ready():
	HUD_draw()

#Обновление отображаемых значений
func HUD_draw():
	$CanvasLayer/Panel/LabelEnergy.text = "En:" + str(Resources.Energy) #Обновление энергии
	$CanvasLayer/Panel/LabelMinerals.text = "Mi:" + str(Resources.Minerals) #Обновление минералов
	$CanvasLayer/Panel/LabelEssence.text = "Es:" + str(Resources.Essence) #Обновление Эссенции


func Timer():
	HUD_draw()


func plusEnergy():
	Resources.Energy += 1


func plusMinerals():
	Resources.Minerals += 1


func plusEssence():
	Resources.Essence += 1
