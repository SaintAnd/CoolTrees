extends StaticBody2D

func _ready():
	randomize()
	var a = int(rand_range(1,4))
	$Cobble.texture = load("res://pic/sprites/cobble%s.png" %  str(a))

	pass 
