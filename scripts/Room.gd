extends StaticBody2D


func room_def(body):
	if body.is_in_group("Worker"):
		print(body)
		body.room_define(self)
