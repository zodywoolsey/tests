extends MeshInstance3D

var size = 500
var cSeed = 0
var noiseScale = 20
var snapScale = .25
var noise : FastNoiseLite = FastNoiseLite.new()
var amesh : ArrayMesh
var verts : PackedVector3Array = PackedVector3Array()
var normals : PackedVector3Array = PackedVector3Array()
var faceNormals : PackedVector3Array = PackedVector3Array()
var genthread : Thread = Thread.new()
var offset = 0

func _ready():
	randomize()
	noise.seed = randi()
	seed(cSeed)
	genthread.start(generate)
#	generate()
	

func _process(delta):
#	if !genthread.is_alive() and genthread.is_started():
#		genthread.wait_to_finish()
#		genthread.start(generate)
	pass

func generate():
	print('generating')
	verts = PackedVector3Array()
	amesh = ArrayMesh.new()
	var mult = .5
	for x in range(size):
		for z in range(size):
			var tmpx = x-(size/2)
			var tmpz = z-(size/2)
			var n = noise.get_noise_2d((tmpx+offset)*mult,(tmpz+offset)*mult)*noiseScale
#			print(n)
			n = snapped(n, snapScale)
#			verts.push_back(Vector3(tmpx,n,tmpz))
			addQuadPoint(Vector3(tmpx,n,tmpz),offset,mult)
#			addBoxPoint(Vector3(tmpx,n,tmpz))
	print('building mesh')
	var meshArr = []
	meshArr.resize(Mesh.ARRAY_MAX)
	meshArr[Mesh.ARRAY_VERTEX] = verts
	meshArr[Mesh.ARRAY_NORMAL] = normals
	
#	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS,meshArr)
	
	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,meshArr)
	print('assign mesh')
	mesh = amesh
	offset += 1
	print('creating collision mesh')
	for child in get_children():
		remove_child(child)
	create_trimesh_collision()
	find_child("CollisionShape3D").hide()
	print("done")

func addBoxPoint(pos:Vector3):
	var tmpOff = Vector3()
	
	tmpOff = Vector3(-.5,0,.5) ; verts.push_back(pos+tmpOff)
	normals.push_back(Vector3.UP)
	tmpOff = Vector3(-.5,0,-.5); verts.push_back(pos+tmpOff)
	normals.push_back(Vector3.UP)
	tmpOff = Vector3(.5,0,-.5) ; verts.push_back(pos+tmpOff)
	normals.push_back(Vector3.UP)
	
	tmpOff = Vector3(-.5,0,.5); verts.push_back(pos+tmpOff)
	normals.push_back(Vector3.UP)
	tmpOff = Vector3(.5,0,-.5); verts.push_back(pos+tmpOff)
	normals.push_back(Vector3.UP)
	tmpOff = Vector3(.5,0,.5) ; verts.push_back(pos+tmpOff)
	normals.push_back(Vector3.UP)

func addQuadPoint(pos:Vector3,offset,mult):
	var y = 0
	var tmpOff = Vector3()
	var tmppos = Vector3(pos.x,0,pos.z)
	
	tmpOff = Vector3(-.5,0,.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(-.5,0,-.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(.5,0,-.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	var tmplen = verts.size()
	faceNormals.push_back( (verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2]) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	
	tmpOff = Vector3(-.5,0,.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(.5,0,-.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(.5,0,.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmplen = verts.size()
	faceNormals.push_back( (verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2]) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	

func calcNormals(v):
	
	
	return v
