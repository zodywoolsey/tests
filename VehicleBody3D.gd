extends VehicleBody3D

var steer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	steering = move_toward(steering,-Input.get_axis("left","right")*.5,delta)
	engine_force = Input.get_axis("backward","forward")*1000
	print(engine_force)
	if Input.is_physical_key_pressed(KEY_E):
		center_of_mass.x+=.01
	if Input.is_physical_key_pressed(KEY_Q):
		center_of_mass.x-=.01
	if Input.is_physical_key_pressed(KEY_Z):
		center_of_mass.z+=.01
	if Input.is_physical_key_pressed(KEY_X):
		center_of_mass.z-=.01
	if Input.is_physical_key_pressed(KEY_R):
		center_of_mass.y+=.01
	if Input.is_physical_key_pressed(KEY_F):
		center_of_mass.y-=.01
