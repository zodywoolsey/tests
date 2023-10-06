extends Node3D
@onready var v_box_container = $Control/HBoxContainer/VBoxContainer

@onready var sub_viewport_container = $SubViewportContainer
@onready var viewp = $SubViewportContainer/SubViewport

var timer := 0.0

# Called when the node enters the scene tree for the first time.
func _process(delta):
	timer += delta
	v_box_container.size.x = (sin(timer)*100.0)
