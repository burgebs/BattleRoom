extends "on_ground.gd"

#idle state can be interrupted by moving.
#Interrupt with jumping is handled in superstate on_ground

func enter():
	owner.get_node("AnimationPlayer").play("idle")

func handle_input(event):
	return .handle_input(event)

func exit():
	.exit()

func update(delta):
	var input_direction = get_input_direction()
	if abs(input_direction.x):
		emit_signal("finished", "running")
	.update(delta)
