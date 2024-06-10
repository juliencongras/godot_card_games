extends Node2D

@onready var deck = $Deck
@onready var draw_recipient = $DrawRecipient

# Called when the node enters the scene tree for the first time.
func _ready():
	deck.shuffleDeck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_dectection_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_dectection_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_mouse_detection_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("Click"):
		drawFromDeck()

func drawFromDeck():
	if deck.deckContent.size() == 0:
		for card in draw_recipient.get_children():
			deck.deckContent.append(str(card.cardSuit, card.cardValue))
			card.queue_free()
	var drawnCard = deck.drawCard()
	draw_recipient.add_child(drawnCard)
	if deck.deckContent.size() == 0:
		deck.deck_sprite.visible = false
	else:
		deck.deck_sprite.visible = true
