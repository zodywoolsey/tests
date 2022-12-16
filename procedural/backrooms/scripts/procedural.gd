extends Node3D

@onready var wall = preload('res://procedural/backrooms/wall.tscn')
@onready var ceiling = preload('res://procedural/backrooms/ceiling.tscn')
@onready var light = preload('res://procedural/backrooms/ceiling_light.tscn')
@onready var corner = preload('res://procedural/backrooms/corner.tscn')
@onready var parts : Array = [wall,ceiling,light,corner]
@onready var map : VoxelGI = $"VoxelGI"
var size = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	var noise :FastNoiseLite = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_VALUE
	noise.seed = 0
	seed(noise.seed)
	var offsetx = -roundi(size/2)
	var offsety = -roundi(size/2)
	for y in range(size):
		for x in range(size):
			var tmpr = -1
			var n = [
				get_node("tile{0}{1}".format([x,y-1])),
				get_node("tile{0}{1}".format([x-1,y])),
			]
			tmpr = randi_range(0,3)
			tmpr = int(round(abs(noise.get_noise_3dv(Vector3((x+offsetx)*40,0,(y+offsety)*40)))*4))
			#corner check
			var walls = [0,0,0,0,0]
			if int(round(abs(noise.get_noise_3dv(Vector3(((x)+offsetx)*40,0,((y+1)+offsety)*40)))*4)) == 0:
				walls[1] = 1
				walls[0] += 1
			if int(round(abs(noise.get_noise_3dv(Vector3(((x+1)+offsetx)*40,0,((y)+offsety)*40)))*4)) == 0:
				walls[2] = 1
				walls[0] += 1
			if int(round(abs(noise.get_noise_3dv(Vector3(((x)+offsetx)*40,0,((y-1)+offsety)*40)))*4)) == 0:
				walls[3] = 1
				walls[0] += 1
			if int(round(abs(noise.get_noise_3dv(Vector3(((x-1)+offsetx)*40,0,((y)+offsety)*40)))*4)) == 0:
				walls[4] = 1
				walls[0] += 1
			if walls[0]>0:
				if randi_range(0,3) == 1:
					tmpr = 3
			elif walls[0]>1:
				tmpr = 3
			var tmppart : Node3D = parts[tmpr].instantiate()
			tmppart.name = "tile{0}{1}".format([x,y])
			add_child(tmppart)
			tmppart.position = Vector3((x+offsetx)*4,0,(y+offsety)*4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
