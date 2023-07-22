extends Node2D
var item = ""

func set_item(item_name):
	$Sprite.texture = load("res://pic/items/%s.png" % item_name)
	item = item_name

func _ready():
	pass 

func _input(event):
	if event.is_action_pressed("e_click"):
		var player = get_parent().get_parent().get_player()
		if abs(player.position.x - position.x) < 64 and abs(player.position.y - position.y) < 64:
			get_parent().remove_child(self)
			player.pick(self)
			
		
