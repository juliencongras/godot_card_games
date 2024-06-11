extends Node2D

@onready var deck = $Deck
@onready var draw_recipient = $DrawRecipient
@onready var final_recipients = $FinalRecipients

# Called when the node enters the scene tree for the first time.
func _ready():
	deck.shuffleDeck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

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
	pass

func _on_update_pressed():
	for cards in final_recipients.get_children():
		cards.updateCardsList()
