@tool
extends EditorScript

@onready var ter = get_scene().find_child('TerrainMesh')

var size = 500
var cSeed = 2
var noiseScale = 20
var noise : FastNoiseLite = FastNoiseLite.new()
var amesh : ArrayMesh
var verts = PackedVector3Array()
var genthread : Thread = Thread.new()
var offset = 0

func _ready():
	if Engine.is_editor_hint():
		if ter:
			noise.seed = cSeed
			seed(cSeed)
		#	genthread.start(generate)
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
#			n = snapped(n, 1.0)
#			verts.push_back(Vector3(tmpx,n,tmpz))
			addQuadPoint(Vector3(tmpx,n,tmpz),offset,mult)
#	print('generated')
	var meshArr = []
	meshArr.resize(Mesh.ARRAY_MAX)
	meshArr[Mesh.ARRAY_VERTEX] = verts
#	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS,meshArr)
	
	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,meshArr)
	mesh = amesh
	offset += 1
	create_trimesh_collision()

func addBoxPoint(pos:Vector3):
	var tmpOff = Vector3()
	
	tmpOff = Vector3(-.5,0,.5) ; verts.push_back(pos+tmpOff)
	tmpOff = Vector3(-.5,0,-.5); verts.push_back(pos+tmpOff)
	tmpOff = Vector3(.5,0,-.5) ; verts.push_back(pos+tmpOff)
	
	tmpOff = Vector3(-.5,0,.5); verts.push_back(pos+tmpOff)
	tmpOff = Vector3(.5,0,-.5); verts.push_back(pos+tmpOff)
	tmpOff = Vector3(.5,0,.5) ; verts.push_back(pos+tmpOff)

func addQuadPoint(pos:Vector3,offset,mult):
	var y = 0
	var tmpOff = Vector3()
	var tmppos = Vector3(pos.x,0,pos.z)
	
	tmpOff = Vector3(-.5,0,.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(-.5,0,-.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(.5,0,-.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	verts.push_back(tmppos+tmpOff)
	
	
	tmpOff = Vector3(-.5,0,.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(.5,0,-.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	verts.push_back(tmppos+tmpOff)
	
	tmpOff = Vector3(.5,0,.5)
	tmpOff.y = noise.get_noise_2d((tmppos.x+offset+tmpOff.x)*mult,(tmppos.z+offset+tmpOff.z)*mult)*noiseScale
	verts.push_back(tmppos+tmpOff)
	
