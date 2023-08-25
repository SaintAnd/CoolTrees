extends Node2D

func update_label(value):
	get_node("UI/Control/Counter").text = "Items: %s" % str(value)


func _ready():
	pass

func _on_Puls_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.
