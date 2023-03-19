extends OmniLight3D

var timer = 9.0
var timeLimit = 1.0
var target := Vector3()
var speed = .1

func _process(delta):
	if timer > timeLimit:
		timeLimit = randf_range(1.0,10.0)
		timer = 0
		target = Vector3(
			randf_range(-100.0,100.0),
			5.0,
			randf_range(-100.0,100.0)			
		)
	timer += delta
	var x = clamp(lerpf(position.x, target.x, .01)-position.x,-speed,speed)
	var y = clamp(lerpf(position.y, target.y, .01)-position.y,-speed,speed)
	var z = clamp(lerpf(position.z, target.z, .01)-position.z,-speed,speed)
	
	position.x += x
	position.z += z
	position.y += y
