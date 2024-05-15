extends Panel

@onready var line_edit = $LineEdit

func _on_button_pressed():
	GameManager.chipsBet = line_edit.text
	GameManager.chipsTotal -= GameManager.chipsBet
	get_parent().visible = false
