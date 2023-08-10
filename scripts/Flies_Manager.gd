extends StaticBody2D

onready var fire_fly = preload("res://scenes/Firefly.tscn")
onready var flies = $Flies

func _ready():
	randomize()
	var a = 5 + randi() % 11
	
	for i in range(a):
		var fly = fire_fly.instance()
		fly.position = Vector2(-3000 + randi() % 3000, -400 + randi() % -100)
		flies.add_child(fly)
		
