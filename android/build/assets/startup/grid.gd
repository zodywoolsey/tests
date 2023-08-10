@tool
extends Node3D

@onready var node_3d : Node3D
@onready var point = preload("res://startup/point.scn")
@export var res : float = 11.0
var tmpres : float = 11.0
@export var size : float = 2.0
var tmpsize : float = 2.0
@export_range(1.0,20.0) var time := 1.0
var goThread : Thread = Thread.new()

func _ready():
	goThread.start(run)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tmpres != res or tmpsize != size:
		goThread.wait_to_finish()
		goThread.start(run)
	tmpres = res
	tmpsize = size

func run():
	for i in get_children():
		i.queue_free()
	node_3d = Node3D.new()
	add_child(node_3d)
	time = clampf(size/2.0,1.0,1000.0)
	for x in range(res):
		for y in range(res):
			for z in range(res):
				var tmp = point.instantiate()
				node_3d.add_child(tmp)
				var tmppos = Vector3( (x-(res/2.0)+.5)*size,(y-(res/2.0)+.5)*size,(-z-(res/2.0)+.5)*size )
				var t = tmp.create_tween()
				t.tween_interval(0.1)
				t.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).tween_property(tmp,"position",tmppos, time)
