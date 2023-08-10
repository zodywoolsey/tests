extends Node3D

@onready var label = $Label
@onready var audio_stream_player = $AudioStreamPlayer
var stream : AudioStreamGeneratorPlayback
var timer = 0

var pitch = .05

var mousepos = Vector2()

func _ready():
	stream = audio_stream_player.get_stream_playback()

func _process(delta):
	audio_stream_player.pitch_scale = lerp(audio_stream_player.pitch_scale,mousepos.length()/10,.1)
	label.text = str(audio_stream_player.pitch_scale)
	mousepos = Vector2()
	timer += stream.get_frames_available()
	var tofill = stream.get_frames_available()
	while tofill > 0:
		stream.push_frame(Vector2.ONE * sin( (timer-tofill)*pitch ))
		tofill -= 1

func _input(event):
	if event is InputEventMouseMotion:
		mousepos = event.relative
