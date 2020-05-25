extends "res://src/state machine/state.gd"

export(float) var DASH_SPEED = 150.0
export(float) var DASH_DISTANCE = 200.0

var dashVelocity = Vector2(0.0,0.0)
var distance_dashed = 0.0

signal used()
signal restored()
# Initialize the state. E.g. change the animation
func enter():
	var input_direction = get_input_direction()
	#print(input_direction)
	if input_direction.length() == 0.0:
		input_direction = owner.look_direction.normalized()
	update_look_direction(input_direction)
	
	dashVelocity = input_direction*DASH_SPEED
	owner.rotate(Vector2.RIGHT.angle_to(input_direction))
	owner.get_node("AnimationPlayer").play("dash_start")
	
	emit_signal("used")
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	owner.set_global_rotation(0)
	return

func handle_input(event):
	if event.is_action("jump"):
		Input.action_release("jump")

func update(delta):
	var added_distance = dashVelocity.length()*delta
	if added_distance >= DASH_DISTANCE - distance_dashed:
		var temp = dashVelocity
		dashVelocity = dashVelocity*(dashVelocity.length()/(DASH_DISTANCE-distance_dashed))
		owner.move_and_slide(dashVelocity)
		dashVelocity = temp
		emit_signal("finished","falling")
	else:
		distance_dashed += added_distance
		owner.move_and_slide(dashVelocity)
	return

func _on_animation_finished(anim_name):
	return

func get_velocity():
	return dashVelocity
