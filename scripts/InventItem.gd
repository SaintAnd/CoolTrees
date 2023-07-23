extends TextureRect

func set_item(item_name, amount):
	texture = load("res://pic/items/%s.png" % item_name)
	$Amount.text = str(amount)
