extends CharacterBody3D

@export var SPEED : float = 100
@export var FLOOR_DRAG : float = 10
@export var AIR_SPEED : float = 10
@export var AIR_DRAG : float = .2
@export var JUMP_VELOCITY : float = 5
@export var JUMP_FORWARD_BOOST : float = 2
@export var WALL_JUMP_VELOCITY : float = 2
@export var GRAVITY : float = 10
@export var WALL_GRAVITY : float = 2
@export var WALL_GRAVITY_MULT : float = 1
@export var MOUSE_SENSITIVITY : float = 100
@export var AUTO_JUMP : bool = false
@export var CEIL_STICKY : bool = true
@export var WALL_STICKY : bool = true
var currentFallSpeed
var wallgrav
@onready var camera : Camera3D = $Camera3D
@onready var overlay = $overlay
@onready var gunray : RayCast3D = $Camera3D/RayCast3D
@onready var ceilray : RayCast3D = $ceilray
@onready var flare = preload("res://player/flare.tscn")
@onready var floor_cast : RayCast3D = $floorCast
@onready var area_3d : Area3D = $playerArea

var direction
var mouseMotion : Vector2
var onground = true
var jumpcount = 0
var shootTimer = 0
var lastPlatformRotation : Vector3
var lastPlatform = null
var lastPlatformPos : Vector3
var container : Area3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	currentFallSpeed = GRAVITY
	overlay.connect("gui_input", overlayInput)

func _physics_process(delta):
	#print(1/delta)
	shootTimer += delta
	var input_dir = Vector2()
	direction = Vector3()
	var jumped = false
	var accel = 8
	if not is_on_floor():
		velocity.y -= currentFallSpeed * delta
	
	if (is_on_wall() or is_on_ceiling()) and !is_on_floor():
		if WALL_STICKY:
			if velocity.y <= 0:
				currentFallSpeed = WALL_GRAVITY
			if velocity.y < -.2:
				velocity.y = -.2
			velocity += (-(Vector3(get_wall_normal().x,0,get_wall_normal().z)/16)*(SPEED*.75))*delta
		if is_on_ceiling() and Input.is_action_pressed("jump") and CEIL_STICKY:
			velocity += (Vector3(0,1,0)*(GRAVITY*2))*delta
	else:
		currentFallSpeed = GRAVITY
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		var basis : Basis = global_transform.basis
		if motion_mode == MOTION_MODE_FLOATING:
			basis = camera.global_transform.basis
		direction = (basis * Vector3(input_dir.x, 0, input_dir.y))
		if AUTO_JUMP:
			if Input.is_action_pressed("jump"):
				jumped = jump()
		else:
			if Input.is_action_just_pressed("jump"):
				jumped = jump()
			
	velocity.x -= (velocity.x*AIR_DRAG)*(delta)
	velocity.z -= (velocity.z*AIR_DRAG)*(delta)
	if onground and is_on_floor() and !jumped:
		velocity.x -= (velocity.x*FLOOR_DRAG)*(delta)
		velocity.z -= (velocity.z*FLOOR_DRAG)*(delta)
		jumpcount = 0


	if direction:
		if is_on_floor():
			velocity += ((direction*SPEED))*delta
			if jumped:
				if velocity.x > 0 and direction.x > 0:
					velocity.x += ((velocity.x*JUMP_FORWARD_BOOST*delta))
				if velocity.x < 0 and direction.x < 0:
					velocity.x += ((velocity.x*JUMP_FORWARD_BOOST*delta))
				if velocity.z > 0 and direction.z > 0:
					velocity.z += ((velocity.z*JUMP_FORWARD_BOOST*delta))
				if velocity.z < 0 and direction.z < 0:
					velocity.z += ((velocity.z*JUMP_FORWARD_BOOST*delta))
				jumpcount += 1
		else:
			velocity += (direction*AIR_SPEED)*delta
			if is_on_wall() and jumped:
				if velocity.x > 0 and direction.x > 0:
					velocity.x += ((velocity.x*JUMP_FORWARD_BOOST*delta))
				if velocity.x < 0 and direction.x < 0:
					velocity.x += ((velocity.x*JUMP_FORWARD_BOOST*delta))
				if velocity.z > 0 and direction.z > 0:
					velocity.z += ((velocity.z*JUMP_FORWARD_BOOST*delta))
				if velocity.z < 0 and direction.z < 0:
					velocity.z += ((velocity.z*JUMP_FORWARD_BOOST*delta))
				jumpcount += 1
	onground = is_on_floor()
	
	#CONTAINER
	if container:
		if lastPlatformRotation != container.global_transform.basis.get_euler() and lastPlatform == container:
			global_rotation += container.global_rotation-lastPlatformRotation
		lastPlatformRotation = container.global_rotation
		lastPlatform = container
	
	
	move_and_slide()
#	move_and_collide(velocity)
#	print(get_floor_angle())
	mouseMotion = Vector2()
	var label = ($Control/Label)
	label.text = "xvel"+str(velocity.x)+"\n"+"yvel"+str(velocity.y)+"\n"+"zvel"+str(velocity.z)+"\n"+"speed: "+str(velocity.length())+"\n"+"x"+str(position.x)+"\n"+"y"+str(position.y)+"\n"+"z"+str(position.z)+"\n"
	
#	if Input.is_action_just_pressed("shoot") and shootTimer>.1:
#		var tmpflare : RigidBody3D = flare.instantiate()
#		tmpflare.global_position = to_global(Vector3(0,0,-1))
#		tmpflare.apply_central_impulse( ((camera.to_global(Vector3(0,0,-1))-camera.global_position).normalized()*10)+velocity )
#		get_tree().root.add_child(tmpflare)


func _input(event):
	if event is InputEventMouseMotion:
		mouseMotion = event.relative
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate(Vector3.UP, ((-mouseMotion.x/100000)*MOUSE_SENSITIVITY) )
			camera.rotate(Vector3.RIGHT, ((-mouseMotion.y/100000)*MOUSE_SENSITIVITY))

func overlayInput(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func jump():
	onground = false
	if is_on_floor():
		velocity += Vector3(get_floor_normal().x*2,1,get_floor_normal().z*2)*JUMP_VELOCITY
		return true
	elif is_on_wall_only():
		velocity += Vector3(get_wall_normal().x*2,0,get_wall_normal().z*2)*WALL_JUMP_VELOCITY
		if velocity.y < JUMP_VELOCITY:
			velocity.y += JUMP_VELOCITY+(WALL_JUMP_VELOCITY)
		return true
	return false

func containerEntered(body):
	container = body
func containerExited(body):
	if container == body:
		container = null
		lastPlatform = null
		lastPlatformRotation = Vector3()
