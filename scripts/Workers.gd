extends Node2D

var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var draw_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()

onready var select_draw = $Select_draw

func _ready():
	for i in get_children():
		i.visible = true
	
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			for unit in selected:
				if unit.collider.is_in_group("Selectable"):
					unit.collider.deselect()
			selected = []
			dragging = true
			drag_start = get_global_mouse_position()
			draw_start = get_local_mouse_position()
		elif dragging:
			dragging = false
			select_draw.update_status(draw_start, get_local_mouse_position(), dragging)
			var drag_end = get_global_mouse_position()
			select_rectangle.extents = (drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rectangle)
			query.transform = Transform2D(0, (drag_end + drag_start)/2)
			selected = space.intersect_shape(query)
			for unit in selected:
				if unit.collider.is_in_group("Selectable"):
					unit.collider.select()
					get_parent().workk.append(unit.collider)
	if dragging:
		if event is InputEventMouseMotion:
			select_draw.update_status(draw_start, get_local_mouse_position(), dragging)

