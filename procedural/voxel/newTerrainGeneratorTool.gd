@tool
extends EditorScript

#@onready var ter : MeshInstance3D = get_scene().find_child('TerrainMesh')
var ter : MeshInstance3D

var size = 200
var cSeed = 0
var noiseScale = 1
var snapScale = .5
var noise : FastNoiseLite = FastNoiseLite.new()
var amesh : ArrayMesh
var verts : PackedVector3Array = PackedVector3Array()
var normals : PackedVector3Array = PackedVector3Array()
var faceNormals : PackedVector3Array = PackedVector3Array()
var genthread : Thread = Thread.new()
var offset = 0

func _run():
	ter = (get_scene().find_child("TerrainMesh"))
	if Engine.is_editor_hint():
		if ter:
			randomize()
			noise.seed = randi()
			seed(cSeed)
#			genthread.start(generate)
			generate()
	

func _process(delta):
#	if !genthread.is_alive() and genthread.is_started():
#		genthread.wait_to_finish()
#		genthread.start(generate)
	pass

func generate():
	verts = PackedVector3Array()
	amesh = ArrayMesh.new()
	var mult = .5
#	print('generating')
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
#	print('generated')
	var meshArr = []
	meshArr.resize(Mesh.ARRAY_MAX)
	meshArr[Mesh.ARRAY_VERTEX] = verts
	meshArr[Mesh.ARRAY_NORMAL] = normals
	
#	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS,meshArr)
	
	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,meshArr)
	amesh.lightmap_unwrap(Transform3D(),1.0)
	ter.mesh = amesh
	offset += 1
	for child in ter.get_children():
		ter.remove_child(child)
	ter.create_trimesh_collision()
	ter.find_child("CollisionShape3D").hide()

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
