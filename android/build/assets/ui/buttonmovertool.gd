extends Button

var time = 0
var oldSize

func _ready():
	pressed.connect(press)
	oldSize = size

func _process(delta):
	time += delta
#	position.x = ((sin(time)+1)/2)*(get_viewport_rect().size.x)

func press():
	var tween = create_tween()
	tween.tween_property(self,"size",size*2,1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"size",oldSize,1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
