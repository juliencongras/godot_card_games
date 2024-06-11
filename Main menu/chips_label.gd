extends Label

func _process(_delta):
	self.text = "Chips: " + str(GameManager.chipsTotal)
