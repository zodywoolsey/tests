extends Node3D



func _ready():
	var voice = DisplayServer.tts_get_voices()[1].name
	DisplayServer.tts_speak("do", voice, 50, .0, 1.0)
	DisplayServer.window_set_drop_files_callback(func(file):
		print(file)
		)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.get_keycode_with_modifiers() == 268435542:
			var clip = DisplayServer.clipboard_get()
			print(clip)
			if clip.begins_with("https://") or clip.begins_with("http://"):
				var req = HTTPRequest.new()
				get_tree().root.add_child(req)
				req.request(clip)
				await req.request_completed
				var img = EditorSceneFormatImporterBlend
				print(req.get_downloaded_bytes())
			
