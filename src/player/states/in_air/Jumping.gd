extends "in_air.gd"

#jump contstraints- jump duration is for the rising part only
export(float) var JUMP_FORCE = -1500.00
export(float) var JUMP_HEIGHT = 200.00
export(float) var JUMP_DURATION = 1.0


# Initialize the state. E.g. change the animation
func enter():
	.enter()
	var animPlayer = owner.get_node("AnimationPlayer")
	animPlayer.play("jump")
	airVelocity=Vector2(0.0,JUMP_FORCE)
	return
	

#enter with speed only keeps the x value- we want to set the initial jump y acceleration to be constant

# Clean up the state. Reinitialize values like a timer
func exit():
	.exit()

func handle_input(event):
	.handle_input(event)
	return

func update(delta):
	.update(delta)
	if airVelocity.y >= 0.0:
		emit_signal("finished","falling")
	return

func _on_animation_finished(anim_name):
	return
