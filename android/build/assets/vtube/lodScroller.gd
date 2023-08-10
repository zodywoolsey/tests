@tool
extends MeshInstance3D

var timer = 0

func _process(delta):
	timer += delta
	extra_cull_margin = remap(sin(timer),-1.0,1.0,.1,500)
