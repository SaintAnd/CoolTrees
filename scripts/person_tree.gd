extends KinematicBody2D

onready var ui = get_viewport().get_node("Root/UI/Control") # Ссылка на интерфейс


var items = 0
var inventory = {}

func _ready():
	pass # Replace with function body.
	
func pick(item):
	var it = item.get_item()
	if it in inventory.keys():
		inventory[it] += item.get_amount()
	else:
		inventory[it] = item.get_amount()
	ui.update_inventory(inventory)


func _process(delta):
	var mouse_pos  = get_viewport().get_mouse_position()
	self.position = mouse_pos
	
	
func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		ui.toggle_inventory(inventory)
