extends Node3D

@onready var mesh_instance_3d = $MeshInstance3D
@onready var camera_3d = $Camera3D
@onready var line_3d : Line3D = $Line3D
@onready var ray_cast_3d = $Camera3D/RayCast3D

var timer := 0.0
var mousepos := Vector2()
var curve := Curve.new()

var Line3D := ArrayMesh.new()
var resolution :int = 14

func _ready():
	camera_3d.project_position(mousepos,4)

func _process(delta):
	timer += delta
	mesh_instance_3d.position = Vector3(sin(timer),cos(timer),cos(timer))
#	camera_3d.position = Vector3(0,0,4)+Vector3(sin(timer),cos(timer),cos(timer))
	camera_3d.look_at(Vector3())
	ray_cast_3d.target_position = ray_cast_3d.to_local(camera_3d.project_position(mousepos,100.0))
	if ray_cast_3d.is_colliding():
		line_3d.target = ray_cast_3d.get_collision_point()
		

func _input(event):
	if event is InputEventMouse:
		mousepos = event.position
