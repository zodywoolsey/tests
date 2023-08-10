@tool
extends MeshInstance3D

func _process(delta):
	set_instance_shader_parameter("pos",global_position)
	set_instance_shader_parameter("rot",global_rotation)
	set_instance_shader_parameter("sca",global_scale)
