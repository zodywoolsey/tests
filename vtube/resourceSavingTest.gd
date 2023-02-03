@tool
extends EditorScript
var thread = Thread.new()

func _run():
	var mesh : ArrayMesh = get_scene().find_child('Body').mesh.duplicate(true)
	for i in range(mesh.get_surface_count()):
		mesh.surface_set_material(i,null)
		print("cleared mesh {0}".format([i]))
	thread.start(func():
		print('starting')
		ResourceSaver.save(mesh.duplicate(false),"res://vtube/arflin/body/bodyMesh.tres")
		print('done')
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if thread.is_started() && !thread.is_alive():
		thread.wait_to_finish()
