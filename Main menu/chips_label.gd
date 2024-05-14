extends Label

func _process(delta):
	self.text = "Chips: " + str(GameManager.chipsTotal)
