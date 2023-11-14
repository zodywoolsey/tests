extends Node3D
@onready var camparent = $camparent

func _ready():
	get_window().files_dropped.connect(func(files):
		var filename:String
		if OS.get_name() == "Windows" or OS.get_name() == "UWP":
			filename = files[0].split('\\')[-1]
		else:
			filename = files[0].split('/')[-1]
		)
	InputMap.add_action("paste")
	var ctrlevent = InputEventKey.new()
	ctrlevent.keycode = KEY_CTRL
	InputMap.action_add_event("paste", ctrlevent)
	var vevent = InputEventKey.new()
	vevent.keycode = KEY_V
	InputMap.action_add_event("paste", vevent)
	

func _process(delta):
	if Input.is_action_just_pressed("ui_paste"):
		var clipboard = DisplayServer.clipboard_get()
		var tmp = Image.new()
		if DisplayServer.clipboard_has_image():
			print('image')
		elif clipboard.begins_with('<svg'):
			var err = tmp.load_svg_from_string(clipboard,1.0)
			print(err)
			var image = Sprite3D.new()
			var tex = ImageTexture.create_from_image(tmp)
			image.texture = tex
			add_child(image)
		

func _input(event):
	if event is InputEventMouseMotion:
		camparent.rotate_y(event.relative.x/500.0)
