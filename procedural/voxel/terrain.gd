extends StaticBody3D
#extends CSGCombiner3D

var size : int = 50
var noise : FastNoiseLite
var offset = 1000
var timer = 0
var toAdd = []
var imesh : ImmediateMesh
var generated = false
var playerLastPos = Vector2()

@onready var addthread : Thread = Thread.new()
@onready var generateThread : Thread = Thread.new()
@onready var deleteThread : Thread = Thread.new()
@onready var csg_mesh_3d = $"CSGMesh3D"
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
#	imesh = csg_mesh_3d.mesh
#	imesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = 0
	seed(noise.seed)
	generateThread.start(generate)
	addthread.start(nextAdd)
	deleteThread.start(markDelete)

func _process(delta):
	timer += delta
	var playerNewPos = snapped(Vector2(player.position.x,player.position.z),Vector2(1.0,1.0))
	if timer > .1:
		if !addthread.is_alive() and addthread.is_started():
			addthread.wait_to_finish()
			addthread.start(nextAdd)
		if !generateThread.is_alive() and playerLastPos!=playerNewPos and generateThread.is_started():
			generateThread.wait_to_finish()
			generateThread.start(generate)
		if !deleteThread.is_alive() and deleteThread.is_started():
			deleteThread.wait_to_finish()
			deleteThread.start(markDelete)
#		markDelete()
		#generate()
	playerLastPos = playerNewPos

func generate(offsetx=0,offsety=0):
	var tmppos = playerLastPos
	print('generating')
	for x in range(size):
		for z in range(size):
			var tmpx = x-(size/2)+tmppos.x
			var tmpz = z-(size/2)+tmppos.y
#			print( " x: {0} y: {1} tx: {2} ty: {3}".format([x,z,tmpx,tmpz]) )
			var tmp = get_tree().get_first_node_in_group(str(tmpx)+","+str(tmpz))
			if !tmp:
#				print(x+z)
				var n = noise.get_noise_2d(tmpx,tmpz)*10
#				print(n)
				n = snapped(n, 1.0)
				addVoxel(tmpx,n,tmpz)
			else:
				tmp.disabled = false
				tmp.show()
	print('generated')

func addVoxel(x,y,z):
	var col : CollisionShape3D = CollisionShape3D.new()
	var boxCol : BoxShape3D = BoxShape3D.new()
	boxCol.size = Vector3(1,1,1)
	col.add_to_group(str(x)+","+str(z))
	col.add_to_group('voxel')
	col.shape = boxCol
	var mesh : MeshInstance3D = MeshInstance3D.new()
	var boxMesh : BoxMesh = BoxMesh.new()
	boxMesh.size = Vector3(1,1,1)
	mesh.mesh = boxMesh
	col.add_child(mesh)
	addToAdd(col,Vector3(x,y,z),str(x)+","+str(z))
	
#	var vox = CSGBox3D.new()
#	addToAdd(vox,Vector3(x,y,z),str(x)+","+str(z))

func addIVoxel(x,y,z):
	imesh.surface_set_material(0, csg_mesh_3d.material)
	imesh.surface_add_vertex(Vector3(x,y,z))
	print("added: {0},{1},{2}".format([x,y,z]))

## Adds node to the queue to be added to the scene
func addToAdd(node,pos,nodename):
	toAdd.push_back([node,pos,nodename])

## Adds the next entry of nodes to be added to the scene and
## removes it from the queue
func nextAdd():
#	print(toAdd.size())
	if toAdd.size() > 100:
		for i in range(100):
			var tmp = toAdd.pop_back()
			if tmp and !get_tree().get_first_node_in_group(tmp[2]):
#				call_deferred("add_child",tmp[0])
				add_child(tmp[0])
				tmp[0].position = tmp[1]
				tmp[0].name = tmp[2]
	else:
		for i in range(toAdd.size()):
			var tmp = toAdd.pop_back()
			if tmp and !get_tree().get_first_node_in_group(tmp[2]):
#				call_deferred("add_child",tmp[0])
				add_child(tmp[0])
				tmp[0].position = tmp[1]
				tmp[0].name = tmp[2]
		toAdd = []
#	if toAdd.size() > 1:
#		var tmpCom = CSGCombiner3D.new()
#		for i in range(toAdd.size()):
#			var tmp = toAdd.pop_back()
#			if tmp and !get_tree().get_first_node_in_group(tmp[2]):
#				tmpCom.add_child(tmp[0])
#				tmp[0].position = tmp[1]
#				tmp[0].name = tmp[2]
#				tmp[0].add_to_group(tmp[2])
#		call_deferred("add_child",tmpCom)

func markDelete():
	var voxels = get_tree().get_nodes_in_group("voxel")
#		print(voxels.size())
	if !voxels.is_empty():
		for vox in voxels:
			if vox.global_position.distance_to(player.global_position) > size:
#				vox.global_position
				vox.add_to_group("deleteme")
				vox.disabled = true
				vox.hide()

func deleteVoxels():
	var voxels = get_tree().get_nodes_in_group("deleteme")
	if voxels.size() > 1:
		for i in range(1):
#			pass
			voxels[i].queue_free()
