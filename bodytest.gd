extends Node3D

@onready var chest : RigidBody3D = $chest
@onready var torso : RigidBody3D = $torso

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		chest.apply_torque(Vector3(-40.0,0,0))
	if Input.is_action_pressed("ui_down"):
		chest.apply_torque(Vector3(20.0,0,0))
