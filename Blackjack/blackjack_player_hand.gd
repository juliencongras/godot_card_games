extends Node2D

@onready var player_hand = $PlayerHand
@onready var hand_score_label = $LabelsContainer/HandScore
@onready var chips_bet = $LabelsContainer/ChipsBet

var handMarginX : int = 60
var handMarginY : int = 120
var handScore : int = 0
var handOffset : int = 0

func _ready():
	player_hand.position = Vector2(handMarginX, handMarginY)

func _process(delta):
	hand_score_label.text = "Hand score: " + str(handScore)

func setHandBet(chips):
	chips_bet.text = "Chips bet: " + str(chips)

func updateHandScore():
	var totalCardScore : int = 0
	for card in player_hand.get_children():
		totalCardScore += card.cardValue
	handScore = totalCardScore

func _on_hit_button_pressed():
	drawCardToHand()

func drawCardToHand():
	get_parent().drawPlayer(player_hand, handOffset, self)
	handOffset += get_parent().cardOffset
