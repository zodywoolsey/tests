extends AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	print(AudioServer.get_input_device_list())
	print(AudioServer.get_output_device_list())
	AudioServer.input_device = "Speakers (G432 Gaming Headset)"
#	AudioServer.input_device = "Microphone (Blue Snowball)"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
