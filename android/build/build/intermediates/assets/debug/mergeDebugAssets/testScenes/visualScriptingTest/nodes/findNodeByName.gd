extends GraphNode


# Called when the node enters the scene tree for the first time.
func _ready():
	slot_updated.connect(func(idx):
		print(get_connection_input_slot(idx))
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
