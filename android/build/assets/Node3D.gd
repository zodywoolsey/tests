extends Node3D

#@onready var rigid = $RigidBody3D
#@onready var label = $Label
#var timer = 0
#var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Engine.time_scale = .5
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	timer+=delta
#	if timer > .0001*count:
#		for i in range(0):
#			var tmp = rigid.duplicate()
#			tmp.freeze = false
#			add_child(tmp)
#			count += 1
#			label.text = str(count)
#			timer = 0
#
#	print(delta)
	pass
