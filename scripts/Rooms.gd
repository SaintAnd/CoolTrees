extends Node2D

var elevators = []

func _ready():
	var rooms = get_children()
	for item in rooms:
		elevators.append(item.get_child(3))
