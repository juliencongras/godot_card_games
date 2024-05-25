extends Node2D

@onready var deck = $Deck
@onready var player_hand = $PlayerHand
@onready var player_split_hand = $PlayerSplitHand
@onready var dealer_hand = $DealerHand
@onready var playerScoreLabel = $PlayerScore
@onready var dealerScoreLabel = $DealerScore
@onready var double_down = $ButtonsContainer/DoubleDown
@onready var split_cards = $ButtonsContainer/SplitCards
@onready var betting_window = $Control


var firstTurn : bool = true
var cardOffset : int = 70
var playerHandOffset : int = 0
var dealerHandOffset : int = 0
var playerScore : int
var dealerScore : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerScoreLabel.text = "Player score : " + str(playerScore)
	dealerScoreLabel.text = "Dealer score : " + str(dealerScore)
	
	if firstTurn:
		double_down.visible = true
		if player_hand.get_child_count() > 1 and player_hand.get_children()[0].originalCardValue == player_hand.get_children()[1].originalCardValue:
			split_cards.visible = true
		else:
			split_cards.visible = false
	else:
		double_down.visible = false
		split_cards.visible = false

func startBlackjackGame():
	#Reset player and dealer scores
	playerScore = 0
	dealerScore = 0
	
	#Reset hands offset
	playerHandOffset = 0
	dealerHandOffset = 0
	
	#Empty dealer and player hands
	for card in player_hand.get_children():
		card.free()
	for card in dealer_hand.get_children():
		card.free()
		
	#Put the cards back in the deck and shuffle
	deck.resetDeck()
	deck.shuffleDeck()
	
	#Add two cards to the player and one card to the dealer hands
	drawPlayer()
	drawDealer()
	drawPlayer()
	
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

func drawPlayer():
	firstTurn = false
	var drawnCard = deck.drawCard()
	var tween = get_tree().create_tween()
	
	drawnCard.originalCardValue = drawnCard.cardValue
	
	if drawnCard.cardValue > 10:
		drawnCard.cardValue = 10
	if drawnCard.cardValue == 1:
		drawnCard.cardValue = 11
	
	drawnCard.position = deck.position - player_hand.position
	tween.tween_property(drawnCard, "position", Vector2(playerHandOffset, 0), 0.3)
	player_hand.add_child(drawnCard)
	playerHandOffset += cardOffset
	
	updatePlayerScore()
	
	if playerScore > 21:
		for card in player_hand.get_children():
			if card.cardValue == 11:
				card.cardValue = 1
				updatePlayerScore()
				break
	
	if playerScore > 21:
		gameEnd()

func updateDealerScore():
	var updatedScore : int = 0
	for card in dealer_hand.get_children():
		updatedScore += card.cardValue
	dealerScore = updatedScore

func updatePlayerScore():
	var updatedScore : int = 0
	for card in player_hand.get_children():
		updatedScore += card.cardValue
	playerScore = updatedScore

func gameEnd():
	if dealerScore == playerScore:
		GameManager.chipsTotal += GameManager.chipsBet
	elif dealerScore > 21 or (dealerScore < playerScore and playerScore < 22):
		GameManager.chipsTotal += GameManager.chipsBet * 2
	GameManager.chipsBet = 0
	

func _on_draw_player_pressed():
	drawPlayer()

func _on_draw_dealer_pressed():
	drawDealer()

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
	drawPlayer()

func _on_split_cards_pressed():
	var targetSplitCard = player_hand.get_children()[1]
	player_hand.remove_child(targetSplitCard)
	player_split_hand.add_child(targetSplitCard)
	updatePlayerScore()
	playerHandOffset -= cardOffset
