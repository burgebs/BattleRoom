extends "res://src/state machine/state.gd"
#

signal on_ground()

onready var groundVelocity:Vector2 = Vector2(0,0)
var ungrounded:bool = false
#onready var groundDetector1 = owner.get_node("GroundDetector1")
#onready var groundDetector2 = owner.get_node("GroundDetector2")

# Initialize the state. E.g. change the animation
func _ready():
	owner.get_node("Raycasts").connect("ungrounded",self,"_on_raycasts_ungrounded")
	owner.get_node("Raycasts").connect("landed",self,"_on_raycasts_landed")
	ungrounded = false
	self.connect("on_ground",owner.get_node("Player State Machine"),"on_grounded_state")

func enter():
	emit_signal("on_ground")

## Clean up the state. Reinitialize values like a timer
func exit():
	groundVelocity = Vector2(0.0,0.0)
#
func handle_input(event):
	if event.is_action_pressed("jump") and !ungrounded:
		emit_signal("finished","jumping")
	if event.is_action_pressed("dash"):
		emit_signal("finished","dashing")
	.handle_input(event)

#if the player finds themself in the air, initiate falling (use )
func update(delta):
	if ungrounded:
		emit_signal("finished","falling")
	.update(delta)

func _on_raycasts_ungrounded():
	ungrounded = true
	
func _on_raycasts_landed():
	ungrounded = false
	
func get_velocity():
	return groundVelocity
	
func add_velocity(vel:Vector2):
	groundVelocity += vel
#func _on_animation_finished(anim_name):
#	return
