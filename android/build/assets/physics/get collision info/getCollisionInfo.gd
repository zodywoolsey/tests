extends RigidBody3D

var State = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(func(body):
		print(State)
		)


func _integrate_forces(state):
	State = state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
