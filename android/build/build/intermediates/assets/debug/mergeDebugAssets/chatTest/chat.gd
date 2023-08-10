extends Control

@onready var msgs = $VBoxContainer/ItemList
@onready var msg = $VBoxContainer/HBoxContainer/TextEdit
@onready var btn = $VBoxContainer/HBoxContainer/Button


func _ready():
	btn.pressed.connect(func ():
		msgs.add_item(msg.text)
		msg.clear()
		)
	var tmp := Shortcut.new()
	tmp.events.append('sendmsg')
	btn.shortcut = tmp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
