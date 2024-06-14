extends Node2D

@onready var card_detection = $CardDetection

var cardOffset : int = 35
var cardsList : Array = []
var hoveredCard

func addCardToColumn(card, forced):
	if (cardsList.size() == 0 and card.cardValue == 13) or (cardsList.size() > 0 and (cardsList[-1].cardValue - 1) == card.cardValue) and (cardsList[-1].cardColor != card.cardColor) or forced:
		var numberOfCards = get_child_count() - 1
		if card.get_parent():
			card.get_parent().remove_child(card)
		card.position = Vector2(0, cardOffset * numberOfCards)
		card.originalPosition = card.position
		add_child(card)
		cardsList.append(card)
		for cards in get_parent().get_children():
			cards.updateCardsList()

func updateCardsList():
	cardsList.clear()
	for card in get_children():
		if card != card_detection:
			cardsList.append(card)

func _on_card_detection_area_entered(area):
	hoveredCard = area.get_parent()

func _on_card_detection_area_exited(_area):
	hoveredCard = null

func _on_card_detection_input_event(_viewport, _event, _shape_idx):
	if hoveredCard != null and Input.is_action_just_released("Click"):
		addCardToColumn(hoveredCard, false)

func _on_child_exiting_tree(_node):
	if get_child(get_child_count() - 2) != card_detection:
		get_child(get_child_count() - 2).changeVisibilityCard()
	updateCardsList()
