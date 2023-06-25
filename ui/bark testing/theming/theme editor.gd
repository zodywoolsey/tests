extends Control

@onready var forearm_menu = %ForearmMenu
@onready var t : Theme = load("res://ui/bark testing/theming/test.theme")
@onready var color_picker = $HBoxContainer/HBoxContainer/ColorPicker
var prevColor :Color

func _ready():
	forearm_menu.theme_changed.connect(func():
		print('theme changed')
		)
	print(t.get_stylebox_list("Button"))

func _process(delta):
	if color_picker.color != prevColor:
		prevColor = color_picker.color
		forearm_menu.set_color(prevColor)
#		t = t.duplicate()
#		var tmp:StyleBoxFlat = t.get_stylebox(
#				"Button",
#				"normal"
#			)
#		tmp.bg_color = color_picker.color
#		print(tmp.bg_color)
#		t.set_stylebox(
#			"Button",
#			"normal",
#			tmp
#		)
#		forearm_menu.theme = t
#	print(forearm_menu.theme.get_stylebox("Button","normal").bg_color)
#	forearm_menu.theme = t
