extends Node2D


func _process(_delta):
	self.position = get_global_mouse_position()
