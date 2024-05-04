extends Node2D

var firstTurn : bool = true
@onready var deck = $Deck
@onready var player_hand = $PlayerHand
@onready var dealer_hand = $DealerHand
var cardOffset : int = 70
var playerHandOffset : int
var dealerHandOffset : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerHandOffset = cardOffset * player_hand.get_child_count()
	dealerHandOffset = cardOffset * dealer_hand.get_child_count()

func startBlackjackGame():
	#Empty dealer and player hands
	for card in player_hand.get_children():
		card.queue_free()
	for card in dealer_hand.get_children():
		card.queue_free()
		
	#Put the cards back in the deck and shuffle
	deck.resetDeck()
	deck.shuffleDeck()
	
	#Add two cards to the dealer and player hands
	drawDealer()
	drawPlayer()
	drawDealer()
	drawPlayer()
	
	firstTurn = true

func drawDealer():
	var drawnCard = deck.drawCard()
	drawnCard.position = Vector2(dealerHandOffset, 0)
	dealer_hand.add_child(drawnCard)

func drawPlayer():
	var drawnCard = deck.drawCard()
	drawnCard.position = Vector2(playerHandOffset, 0)
	player_hand.add_child(drawnCard)

func _on_draw_player_pressed():
	drawPlayer()

func _on_draw_dealer_pressed():
	drawDealer()
