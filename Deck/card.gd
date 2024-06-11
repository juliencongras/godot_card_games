extends Node2D

var cardValue : int
var cardSuit : String
var originalCardValue : int
var cardSpritePath : String = "res://Assets/Cards/"
var cardSprite : String
var solitaireMode : bool = false
var originalPosition : Vector2
var cardGrabbed = false

@onready var sprite_2d = $Sprite2D
@onready var mouse_detection = $MouseDetection

# Called when the node enters the scene tree for the first time.
func _ready():
	originalPosition = position
	mouse_detection.visible = solitaireMode
	sprite_2d.texture = load(cardSpritePath + cardSprite + ".png")
	sprite_2d.scale = Vector2(0.5, 0.5)

func _process(delta):
	if solitaireMode:
		if cardGrabbed:
			global_position = get_global_mouse_position()
		else:
			position = originalPosition

func _on_mouse_detection_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("Click"):
		cardGrabbed = true
	elif Input.is_action_just_released("Click"):
		cardGrabbed = false
