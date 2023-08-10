extends Node2D


onready var anim1 = $Sprite/Anim1
onready var anim2 = $Sprite/Light2D/Anim2
onready var timer = $Timer
onready var tween = $Tween
onready var polygon = get_parent()



func _ready():
	anim1.play("firefly")
	anim2.play("fly_glow")
	
	
func fly():
	randomize()
	var pos = position + Vector2(int(rand_range(-500, 500)), int(rand_range(-500, 500))) 
	
	if Geometry.is_point_in_polygon(pos, polygon.polygon):
		if position.x - pos.x <= 0: scale.x = -scale.x
		else: scale.x = +scale.x
		
		tween.interpolate_property(self, "position", position, pos, 1)
		tween.start()
		yield(tween, "tween_completed")
	else: fly()
	
	timer.wait_time = 2 + randi() % 5
