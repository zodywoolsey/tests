extends CSGMesh3D

@onready var cam : Camera3D = $"../Camera3D"
@onready var ray : RayCast3D = $"../RayCast3D"
@onready var meshin : MeshInstance3D = $"../MeshInstance3D"
@onready var meshcom : CSGCombiner3D = $"CSGCombiner3D"
@onready var window = preload("res://destructive clicks/window.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		mesh = get_meshes()[1]
		for child in meshcom.get_children():
			meshcom.remove_child(child)

func _input(event):
	if event is InputEventMouseMotion:
		ray.global_position = cam.global_position
		ray.global_position = cam.project_ray_origin(event.position)
		ray.target_position = ray.to_local(cam.project_position(event.position,100))
	if event is InputEventMouseButton:
		if event.pressed:
			mesh = get_meshes()[1]
			for child in meshcom.get_children():
				meshcom.remove_child(child)
		if !event.pressed:
			if ray.is_colliding():
				var tmp = window.instantiate()
				meshcom.add_child(tmp)
				tmp.global_position = ray.get_collision_point()
			
		
