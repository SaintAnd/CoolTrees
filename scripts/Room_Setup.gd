extends Area2D


onready var rooms = get_parent().get_parent()

func _ready():
	self.connect("body_entered", self, "room_idx")
	self.connect("input_event", rooms, "on_Mouse_Click_input_event")

func room_idx(object):
	rooms.on_Mouse_Click_body_entered(get_parent(), object)
