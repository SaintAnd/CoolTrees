extends Node2D

#onready var item = preload("res://scenes/item.tscn")

func get_player():
	return $Player
	
func update_label(value):
	get_parent().update_label(value)

func _ready():
	var items = ["Ruda_Cink", "Ruda_Kalciy", "Ruda_Medi", "Ruda_metal", "Ruda_marganec1"]
	for _i in range (11):
		randomize()
		var a = int(rand_range(0,5))
		#var new_item = item.instance()
		#$Items.add_child(new_item)
		#new_item.set_item(items[a])
		#new_item.position = Vector2(int(rand_range(0,16*59)), int(rand_range(16*30,16*44)))
	pass 
