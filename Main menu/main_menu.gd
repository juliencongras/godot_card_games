extends Control

@export var blackjackScene : PackedScene

func _on_blackjack_button_pressed():
	get_tree().change_scene_to_packed(blackjackScene)

func _on_quit_button_pressed():
	get_tree().quit()
