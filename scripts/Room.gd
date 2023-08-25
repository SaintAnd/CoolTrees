extends StaticBody2D


func room_def(body):
	if body.is_in_group("Worker"):
		body.room_define(self)
