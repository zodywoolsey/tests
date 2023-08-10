class_name Line3D
extends MeshInstance3D

var mat : BaseMaterial3D

var amesh := ArrayMesh.new()
var vertices := PackedVector3Array()

var res := 100.0

var timer := 0.0

var target := Vector3()

func _init():
	for i in range(res):
		vertices.append(Vector3(sin(i)*(i/(res*0.5)),cos(i)*(i/(res*0.5)),0))
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP,arrays)
	mesh = amesh

func _ready():
	amesh

func _process(delta):
	timer+=delta
	for i in range(res):
		var newpos = lerp(global_position,target,i/res)
		vertices[i] = lerp(vertices[i],to_local(newpos), clamp(0.5,1.0,i/res/2.0) )
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	amesh.clear_surfaces()
	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP,arrays)
