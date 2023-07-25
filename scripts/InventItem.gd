extends TextureRect

func set_item(item_name, amount):
	texture = load("res://pic/Resource/%s.png" % item_name)
	$Amount.text = str(amount)
