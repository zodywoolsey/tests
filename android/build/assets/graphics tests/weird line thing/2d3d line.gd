extends Node3D

@onready var mesh_instance_3d = $MeshInstance3D
@onready var camera_3d = $Camera3D
@onready var line_2d = $Line2D

var timer := 0.0
var mousepos := Vector2()
var curve := Curve.new()
var res = 400.0
var scalefactor = .2

func _ready():
	line_2d.width_curve = curve
	curve.add_point(Vector2(0.0,.1))
	curve.add_point(Vector2(1.0,.1))
	var remainingpoints = res - line_2d.get_point_count()
	for i in range(remainingpoints):
		line_2d.add_point(Vector2())
	
	camera_3d.project_position(mousepos,4)

func _process(delta):
	timer += delta
	mesh_instance_3d.position = Vector3(sin(timer)*2.0,cos(timer)*2.0,cos(timer)*2.0)
#	mesh_instance_3d.position = camera_3d.project_position(mousepos,4)
	curve.set_point_value(0, 1.0/global_position.distance_to(mesh_instance_3d.global_position))
	curve.set_point_value(1, 1.0/get_viewport().get_camera_3d().global_position.distance_to(mesh_instance_3d.global_position))
	var tmppos = mesh_instance_3d.position
	for i in range(res):
		var from = line_2d.get_point_position(i)
		var to = camera_3d.unproject_position(lerp(Vector3(),tmppos,i/res))
		var new = lerp(from, to, clampf(64.0/i,0.001,1.0))
		line_2d.set_point_position(i, new)
		

func _input(event):
	if event is InputEventMouse:
		mousepos = event.position
