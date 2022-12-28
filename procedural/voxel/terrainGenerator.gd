extends Node3D

var size = 50
var chunks = 40
var cSeed = 3
var noiseScale = 500.0
var noiseFreq = 0.01
var snapScale = 0.0
var noise : FastNoiseLite = FastNoiseLite.new()
var verts : PackedVector3Array = PackedVector3Array()
var normals : PackedVector3Array = PackedVector3Array()
var faceNormals : PackedVector3Array = PackedVector3Array()
var genthread : Thread = Thread.new()

var grassMaterial = preload("res://procedural/voxel/assets/grass.tres")

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
	for cx in range(chunks):
		for cz in range(chunks):
#			print('generating')
			verts = PackedVector3Array()
			normals = PackedVector3Array()
			faceNormals = PackedVector3Array()
			var amesh = ArrayMesh.new()
			var meshins = MeshInstance3D.new()
			for x in range(size):
				for z in range(size):
					var tmpx = (x-(size/2))+((cx-(chunks/2))*size)
					var tmpz = (z-(size/2))+((cz-(chunks/2))*size)
#					var n = noise.get_noise_2d((tmpx+offset)*noiseFreq,(tmpz+offset)*noiseFreq)*noiseScale
#					print(n)
#					n = snapped(n, snapScale)
#					verts.push_back(Vector3(tmpx,n,tmpz))
					addQuadPoint(Vector3(tmpx,0,tmpz),noiseFreq)
#					addBoxPoint(Vector3(tmpx,n,tmpz))
		
#			print('building mesh')
			var meshArr = []
			meshArr.resize(Mesh.ARRAY_MAX)
			meshArr[Mesh.ARRAY_VERTEX] = verts
			meshArr[Mesh.ARRAY_NORMAL] = normals
			
		#	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS,meshArr)
			
			
			amesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,meshArr)
#			print('assign mesh')
			meshins.mesh = amesh
#			print('creating collision mesh')
			meshins.create_trimesh_collision()
#			find_child("CollisionShape3D").hide()
			meshins.material_override = grassMaterial
			call_deferred("add_child", meshins)
#			print("done")

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

func addQuadPoint(pos:Vector3,mult):
	var y = 0
	var tmpOff = Vector3()
	var tmppos = Vector3(pos.x,0,pos.z)
	
	tmpOff = Vector3(-.5,0,.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+tmpOff.x)*mult,(tmppos.z+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(-.5,0,-.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+tmpOff.x)*mult,(tmppos.z+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(.5,0,-.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+tmpOff.x)*mult,(tmppos.z+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	var tmplen = verts.size()
	faceNormals.push_back( (verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2]) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	
	tmpOff = Vector3(-.5,0,.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+tmpOff.x)*mult,(tmppos.z+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(.5,0,-.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+tmpOff.x)*mult,(tmppos.z+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(.5,0,.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+tmpOff.x)*mult,(tmppos.z+tmpOff.z)*mult)*noiseScale
	tmpOff.y = snappedf(tmpOff.y,snapScale)
	verts.push_back(tmppos+tmpOff)
	
	tmplen = verts.size()
	faceNormals.push_back( (verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2]) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	normals.push_back( -((verts[tmplen-1]-verts[tmplen-3]).cross(verts[tmplen-1]-verts[tmplen-2])) )
	

func calcNormals(v):
	
	
	return v
