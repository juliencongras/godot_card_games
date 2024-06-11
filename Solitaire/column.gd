extends Node2D

var cardOffset : int = 70
var cardCurrentOfset : int = 0

func addCardToColumn(card):
	card.position = Vector2(0, cardCurrentOfset)
	cardCurrentOfset += cardOffset
