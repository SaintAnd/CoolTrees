extends RichTextLabel



func _ready() -> void: 
	$Tween.interpolate_property(
		self, "percent_visible",
		0.0, 2.0, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	

