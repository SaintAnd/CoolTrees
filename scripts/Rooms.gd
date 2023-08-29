extends Node2D

var elevators = []
onready var manager = get_node("../../Workers_Manager")

func _ready():
	var rooms = $Rooms.get_children()
	for item in rooms:
		elevators.append(item.get_child(2))

func click_input(_viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		if manager.click_active:
			manager.click_event(event, shape_idx)

