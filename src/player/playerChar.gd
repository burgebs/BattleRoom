class_name playerChar
extends KinematicBody2D

onready var hitBox = $CollisionShape2D
onready var shape_position = hitBox.get_position()
onready var shape_rotation = hitBox.get_rotation()

# Called when the node enters the scene tree for the first time.
func _ready():
	shape_position = hitBox.get_position()
	shape_rotation = hitBox.get_rotation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shape_position = hitBox.get_position()
	shape_rotation = hitBox.get_rotation()

#takes a vector2 and makes the scene flip to the x direction of that vector
func align_scene_x(direction:Vector2):
	var x_direction = sign(direction.x)
	if x_direction != sign(shape_position.x):
		shape_position.x = -shape_position.x
		shape_rotation = -shape_rotation
		$CollisionShape2D.set_position(shape_position)
		$CollisionShape2D.set_rotation(shape_rotation)
	if x_direction == 1:
		$Sprite.set_flip_h(false)
	elif x_direction == -1:
		$Sprite.set_flip_h(true)
