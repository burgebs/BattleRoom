"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""
extends Node

signal finished(next_state_name)

# Initialize the state. E.g. change the animation
func enter():
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return

func update(delta):
	
	return

func _on_animation_finished(anim_name):
	return

"""
helper functions for particular implementation
"""

#gets the current combination of arrow keys.
func get_input_direction() -> Vector2:
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction

#The player look direction changes to match the passed vector
func update_look_direction(look_vector:Vector2) -> void:
	var direction = look_vector.normalized()
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
