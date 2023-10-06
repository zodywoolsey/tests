extends ItemList

func _ready():
	clear()
	for i in 1000:
		add_item(random_text())


func random_text()->String:
	var string := ''
	for a in range(randi_range(5, 20)):
		for i in range(randi_range(5, 20)):
			string += Array("qwertyuiopasdfghjklzxcvbnm".split()).pick_random()
	return string
