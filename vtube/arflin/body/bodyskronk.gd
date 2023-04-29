@tool
extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	extra_cull_margin = global_position.distance_squared_to(get_viewport().get_camera_3d().global_position)*50
