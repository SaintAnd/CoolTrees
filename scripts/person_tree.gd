extends KinematicBody2D

var speed = 200
var items = 0

func _ready():
	pass # Replace with function body.
	
func pick(item):
	items += 1
	print ("Items: %s" % str(items))
	


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
	
