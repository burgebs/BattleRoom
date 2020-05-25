class_name adventurer
extends playerChar



export(float) var HITBOX_WIDTH = 4.0
export(float) var HITBOX_HEIGHT = 10.0

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var look_direction = Vector2(1,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("ready")

	


	

