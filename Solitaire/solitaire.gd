extends Node2D

@onready var deck = $Deck
@onready var draw_recipient = $DrawRecipient
@onready var final_recipients = $FinalRecipients
@onready var column_recipients = $ColumnRecipients

# Called when the node enters the scene tree for the first time.
func _ready():
	startGame()

func _on_mouse_dectection_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_dectection_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_mouse_detection_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("Click"):
		drawFromDeck()

func drawFromDeck():
	if deck.deckContent.size() == 0:
		for card in draw_recipient.get_children():
			deck.deckContent.append(str(card.cardSuit, card.cardValue))
			card.queue_free()
	var drawnCard = deck.drawCard()
	drawnCard.solitaireMode = true
	draw_recipient.add_child(drawnCard)
	if deck.deckContent.size() == 0:
		deck.deck_sprite.visible = false
	else:
		deck.deck_sprite.visible = true

func startGame():
	deck.shuffleDeck()
	var columnCount : int = 0
	for column in column_recipients.get_children():
		for i in columnCount:
			var drawnCard = deck.drawCard()
			drawnCard.solitaireMode = true
			drawnCard.cardHidden = true
			column.addCardToColumn(drawnCard, true)
		var drawnCard2 = deck.drawCard()
		drawnCard2.solitaireMode = true
		column.addCardToColumn(drawnCard2, true)
		columnCount += 1
