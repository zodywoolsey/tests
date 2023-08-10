@tool
extends MeshInstance3D

@onready var vehicle_body_3d = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	global_position = vehicle_body_3d.to_global(vehicle_body_3d.center_of_mass)
