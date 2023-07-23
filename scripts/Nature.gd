extends Node2D

var can_place = true
var is_panning = true;
onready var editor = get_node("../../Node2D/cam_container")
onready var editor_cam = editor.get_node("Camera")

export var cam_spd = 10
var current_item

func _ready():
	editor_cam.current = true
	pass 
	
func _process(delta):
	
	move_editor()
	is_panning = Input.is_action_pressed("move_cam")
	pass
	
func move_editor():
	if Input.is_action_pressed("w"):
		editor.global_position.y -= cam_spd
	if Input.is_action_pressed("a"):
		editor.global_position.x -= cam_spd
	if Input.is_action_pressed("s"):
		editor.global_position.y += cam_spd
	if Input.is_action_pressed("d"):
		editor.global_position.x += cam_spd
	pass
	
func _unhandled_input(event):

	if(event is InputEventMouseMotion):
		if(is_panning):
			editor.global_position -= event.relative * editor_cam.zoom
	pass

func move_to_player(pos):
	# сделать передвижение камеры на активного персонажа
	pass
