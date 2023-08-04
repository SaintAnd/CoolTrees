extends Node2D


onready var anim1 = $Sprite/Anim1
onready var anim2 = $Sprite/Light2D/Anim2
onready var timer = $Timer
onready var tween = $Tween



func _ready():
	anim1.play("firefly")
	anim2.play("fly_glow")
	
	
func fly():
	randomize()
	timer.wait_time = 2 + randi() % 6
	var pos = Vector2(position.x + int(rand_range(-500, 500)), position.y + int(rand_range(-500, 500)))
	
	if -1500 < pos.x and pos.x < 1500 and -50 < pos.y and pos.y < 400:
		if position.x - pos.x <= 0: scale.x = -scale.x
		else: scale.x = +scale.x
		
		tween.interpolate_property(self, "position", position, pos, 1)
		tween.start()
		yield(tween, "tween_completed")
