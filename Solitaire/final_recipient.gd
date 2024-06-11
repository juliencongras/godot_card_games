extends Node2D

var cardsList : Array = []
var hoveredCard

func addCard(card):
	if (cardsList.size() == 0 and card.cardValue == 1) or (cardsList.size() > 0 and (cardsList[-1].cardValue + 1) == card.cardValue) and (cardsList[-1].cardSuit == card.cardSuit):
		card.get_parent().remove_child(card)
		card.position = Vector2.ZERO
		add_child(card)
		cardsList.append(card)

func updateCardsList():
	cardsList.clear()
	for card in get_children():
		cardsList.append(card)

func _on_card_detection_area_entered(area):
	hoveredCard = area.get_parent()

func _on_card_detection_area_exited(area):
	hoveredCard = null

func _on_card_detection_input_event(viewport, event, shape_idx):
	if hoveredCard != null and Input.is_action_just_released("Click"):
		addCard(hoveredCard)
