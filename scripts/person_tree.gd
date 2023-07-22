extends KinematicBody2D

onready var ui = get_viewport().get_node("Root/UI/Control") # Ссылка на интерфейс

var speed = 200
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
	var velocity = Vector2()
	if Input.is_action_pressed("Up"):
		velocity.y -= speed
	if Input.is_action_pressed("Down"):
		velocity.y += speed
	if Input.is_action_pressed("Left"):
		velocity.x -= speed
	if Input.is_action_pressed("Right"):
		velocity.x += speed
	move_and_slide(velocity)
	position.x = clamp(position.x, 0,1000)
	position.y = clamp(position.y, 0,1000)
	
func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		ui.toggle_inventory(inventory)
