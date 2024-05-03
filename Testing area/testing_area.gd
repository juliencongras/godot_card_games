extends Node2D

@onready var deck = $Deck
@export var cardScene : PackedScene
@onready var cards_zone = $CardsZone

func _on_draw_button_pressed():
	var drawnCard = deck.drawCard()
	cards_zone.add_child(drawnCard)

func _on_shuffle_button_pressed():
	deck.shuffleDeck()

func _on_reset_button_pressed():
	deck.resetDeck()
	for card in cards_zone.get_children():
		card.queue_free()
