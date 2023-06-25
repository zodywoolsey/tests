extends Button


func _ready():
	get_window().mode = 4
	pressed.connect(func():
		print('mode change')
		if get_window().mode == 4:
			get_window().mode = 0
		else:
			get_window().mode = 4
		)
