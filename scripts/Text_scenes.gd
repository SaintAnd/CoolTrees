extends Node2D

onready var text = get_node("../../Node2D/Text_scenes")
onready var editor_text = text.get_node("Text_PressEnter")




func _input(event):
	if event.is_action_pressed("Enter"):
		get_parent().remove_child(self)


	
	
