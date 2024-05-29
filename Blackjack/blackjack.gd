extends Node2D

@onready var deck = $Deck
@onready var dealer_hand = $DealerHand
@onready var dealerScoreLabel = $DealerScore
@onready var double_down = $ButtonsContainer/DoubleDown
@onready var split_cards = $ButtonsContainer/SplitCards
@onready var betting_window = $Control
@onready var blackjack_player_hand_container = $BlackjackPlayerHand
@onready var blackjack_player_hand = $BlackjackPlayerHand/PlayerHand

@export var split_blackjack_player_hand_container : PackedScene

var firstTurn : bool = true
var cardOffset : int = 70
var dealerHandOffset : int = 0
var dealerScore : int
var splitPlayerHand

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dealerScoreLabel.text = "Dealer score : " + str(dealerScore)
	
	if firstTurn:
		double_down.visible = true
		if blackjack_player_hand.get_child_count() > 1 and blackjack_player_hand.get_children()[0].originalCardValue == blackjack_player_hand.get_children()[1].originalCardValue:
			split_cards.visible = true
		else:
			split_cards.visible = false
	else:
		double_down.visible = false
		split_cards.visible = false

func startBlackjackGame():
	#Clear player hand group
	for i in get_tree().get_nodes_in_group("playerHand"):
		i.remove_from_group("playerHand")
		if i != blackjack_player_hand_container:
			i.queue_free()
	
	#Reset dealer scores
	dealerScore = 0
	
	#Reset hands offset
	blackjack_player_hand_container.handOffset = 0
	dealerHandOffset = 0
	
	#Empty dealer and player hands
	for card in blackjack_player_hand.get_children():
		card.free()
	for card in dealer_hand.get_children():
		card.free()
		
	#Put the cards back in the deck and shuffle
	deck.resetDeck()
	deck.shuffleDeck()
	
	#Reset hit button from player's hands
	$BlackjackPlayerHand/HitButton.disabled = false
	
	#Add two cards to the player and one card to the dealer hands
	blackjack_player_hand_container.drawCardToHand()
	drawDealer()
	blackjack_player_hand_container.drawCardToHand()
	
	blackjack_player_hand_container.add_to_group("playerHand")
	
	firstTurn = true

func drawDealer():
	firstTurn = false
	var drawnCard = deck.drawCard()
	var tween = get_tree().create_tween()
	
	drawnCard.originalCardValue = drawnCard.cardValue
	
	if drawnCard.cardValue > 10:
		drawnCard.cardValue = 10
	if drawnCard.cardValue == 1:
		drawnCard.cardValue = 11
	
	drawnCard.position = deck.position - dealer_hand.position
	tween.tween_property(drawnCard, "position", Vector2(dealerHandOffset, 0), 0.3)
	dealer_hand.add_child(drawnCard)
	dealerHandOffset += cardOffset
	
	updateDealerScore()
	
	if dealerScore > 21:
		for card in dealer_hand.get_children():
			if card.cardValue == 11:
				card.cardValue = 1
				updateDealerScore()
				break
	
	if dealerScore > 21:
		gameEnd()

func drawPlayer(targetHand, targetOffset, handParent):
	firstTurn = false
	var drawnCard = deck.drawCard()
	var tween = get_tree().create_tween()
	
	drawnCard.originalCardValue = drawnCard.cardValue
	
	if drawnCard.cardValue > 10:
		drawnCard.cardValue = 10
	if drawnCard.cardValue == 1:
		drawnCard.cardValue = 11
	
	drawnCard.position = deck.position - (handParent.position + targetHand.position)
	tween.tween_property(drawnCard, "position", Vector2(targetOffset, 0), 0.3)
	targetHand.add_child(drawnCard)
	
	handParent.updateHandScore()
	
	if handParent.handScore > 21:
		for card in targetHand.get_children():
			if card.cardValue == 11:
				card.cardValue = 1
				handParent.updateHandScore()
				break
	
	if handParent.handScore > 21:
		gameEnd()

func updateDealerScore():
	var updatedScore : int = 0
	for card in dealer_hand.get_children():
		updatedScore += card.cardValue
	dealerScore = updatedScore

func gameEnd():
	for i in get_tree().get_nodes_in_group("playerHand"):
		if dealerScore == i.handScore:
			GameManager.chipsTotal += GameManager.chipsBet
		elif dealerScore > 21 or (dealerScore < i.handScore and i.handScore < 22):
			GameManager.chipsTotal += GameManager.chipsBet * 2
	GameManager.chipsBet = 0

func dealerTurn():
	while dealerScore < 17:
		drawDealer()
	gameEnd()

func _on_dealer_turn_pressed():
	dealerTurn()

func _on_start_game_pressed():
	startBlackjackGame()
	betting_window.visible = true

func _on_double_down_pressed():
	var initialBet = GameManager.chipsBet
	GameManager.chipsBet *= 2
	GameManager.chipsTotal -= initialBet
	drawPlayer(blackjack_player_hand, blackjack_player_hand_container.handOffset, blackjack_player_hand_container)
	$BlackjackPlayerHand/HitButton.disabled = true

func _on_split_cards_pressed():
	splitPlayerHand = split_blackjack_player_hand_container.instantiate()
	splitPlayerHand.position = Vector2(550, blackjack_player_hand_container.position.y)
	add_child(splitPlayerHand)
	
	var targetSplitCard = blackjack_player_hand.get_children()[1]
	blackjack_player_hand.remove_child(targetSplitCard)
	targetSplitCard.position = Vector2.ZERO
	splitPlayerHand.player_hand.add_child(targetSplitCard)
	
	blackjack_player_hand_container.updateHandScore()
	splitPlayerHand.updateHandScore()
	
	blackjack_player_hand_container.handOffset -= cardOffset
	splitPlayerHand.handOffset += cardOffset
	
	GameManager.chipsTotal -= GameManager.chipsBet
	splitPlayerHand.setHandBet()
