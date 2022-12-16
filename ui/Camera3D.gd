extends Camera3D

@onready var uiRay = $RayCast3D

# projects a position using the main camera and uses that as the ray's target location
# then calls ui() function
func _input(event):
	if event is InputEventMouseMotion:
		uiRay.target_position = to_local(project_position(event.position,100))
		ui(event)
	if event is InputEventMouseButton:
		uiRay.target_position = to_local(project_position(event.position,100))
		ui(event)

# if the ray is colliding with something that is in the "3dui" group:
# send the collision point and the current input event
func ui(e):
	if uiRay.is_colliding():
		var col = uiRay.get_collider()
		if col.is_in_group("3dui"):
			col.input({"pos":uiRay.get_collision_point(),"event":e})
