tool
extends Node2D
var item = ""
var amount = 1

#onready var _timer: Timer = $Timer

func set_item(item_name):
	$Sprite.texture = load("res://pic/Resource/%s.png" % item_name)
	item = item_name
	
func _ready():
	pass 
	
func get_item():
	return item
	
func get_amount():
	return amount


func _unhandled_input(event):
	

		
		if(event is InputEventMouseMotion):
		
			var player = get_parent().get_parent().get_player()
			if abs(player.position.x - position.x) < 64 and abs(player.position.y - position.y) < 64:	
				player.pick(self)
