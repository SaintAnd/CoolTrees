extends Node2D
onready var item = preload("res://scenes/item.tscn")

func get_player():
	return $Player

func _ready():
	var items = ["green", "yellow", "yellow-green"]
	for i in range (16):
		randomize()
		var a = int(rand_range(0,3))
		var new_item = item.instance()
		$Items.add_child(new_item)
		new_item.set_item(items[a])
		new_item.position = Vector2(int(rand_range(0,16*64)), int(rand_range(0,16*28)))
	pass 
