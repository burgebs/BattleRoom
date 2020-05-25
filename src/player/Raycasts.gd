extends RayCast2D

onready var grounded = true
onready var groundDetect1 = $GroundDetector1
onready var groundDetect2 = $GroundDetector2
#onready var groundDetect1 = owner.get_node("GroundDetector1")
#onready var groundDetect2 = owner.get_node("GroundDetector2")
signal landed()
signal grounded()
signal ungrounded()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if (groundDetect1.is_colliding() or groundDetect2.is_colliding()):
		if grounded == false:
			emit_signal("landed")
			grounded = true
		else:
			emit_signal("grounded")
		
	elif !groundDetect1.is_colliding() and !groundDetect2.is_colliding() and grounded==true:
		emit_signal("ungrounded")
		grounded = false
