extends "in_air.gd"


# Initialize the state. E.g. change the animation
#to do: start falling animation if smrslt is not playing. otherwise do not interrupt animation
#initialize variables
func enter():
	owner.get_node("AnimationPlayer").play("fall")
	.enter()
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	.exit()

func handle_input(event):
	.handle_input(event)
	return

func update(delta):
	.update(delta)
	return

#func _on_animation_finished(anim_name):
#	return
