extends Node2D

var cardValue : int
var cardSuit : String
var originalCardValue : int
var cardSpritePath : String = "res://Assets/Cards/"
var cardSprite : String
var solitaireMode : bool = false
var originalPosition : Vector2
var cardGrabbed : bool = false
var cardHidden : bool = false
var columnCardPicked : bool = false
var inColumn : bool = false
var cardColor : String

@onready var sprite_2d = $Sprite2D
@onready var mouse_detection = $MouseDetection

# Called when the node enters the scene tree for the first time.
func _ready():
	originalPosition = position
	mouse_detection.visible = solitaireMode
	
	if cardSuit == "c" or cardSuit == "s":
		cardColor = "black"
	elif cardSuit == "h" or cardSuit == "d":
		cardColor = "red"
	
	if cardHidden:
		sprite_2d.texture = load(cardSpritePath + "1B.png")
	else:
		sprite_2d.texture = load(cardSpritePath + cardSprite + ".png")
		
	sprite_2d.scale = Vector2(0.5, 0.5)

func _process(_delta):
	if solitaireMode:
		if cardGrabbed:
			global_position = get_global_mouse_position()
		elif columnCardPicked:
			global_position = get_global_mouse_position() + Vector2(0, 30)
		else:
			position = originalPosition

func _on_mouse_detection_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("Click") and (get_parent().get_child(-1) == self or inColumn == true) and !cardHidden:
		cardGrabbed = true
		z_index = 1
		for card in get_parent().get_children():
			if card != self and card.get_index() > get_index():
				columnCardPicked = true
	elif Input.is_action_just_released("Click"):
		cardGrabbed = false
		columnCardPicked = false
		z_index = 0

func changeVisibilityCard():
	cardHidden = !cardHidden
	if cardHidden:
		sprite_2d.texture = load(cardSpritePath + "1B.png")
	else:
		sprite_2d.texture = load(cardSpritePath + cardSprite + ".png")
