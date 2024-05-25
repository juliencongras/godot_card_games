extends Node2D

var cardValue : int
var cardSuit : String
var originalCardValue : int
var cardSpritePath : String = "res://Assets/Cards/"
var cardSprite : String
@onready var sprite_2d = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = load(cardSpritePath + cardSprite + ".png")
	sprite_2d.scale = Vector2(0.5, 0.5)
