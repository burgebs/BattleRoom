extends "on_ground.gd"


#"""
#Base interface for all states: it doesn't do anything in itself
#but forces us to pass the right arguments to the methods below
#and makes sure every State object had all of these methods.
#"""
#

#variables for running:
export(float) var RUNNING_ACCELERATION = 600.0
export(float) var TOP_RUN_SPEED = 300.00
export(float) var TOP_GROUND_SPEED = 500.0
export(float,1.0,200.00) var GROUND_FRICTION = 400.0 #also used in deceleration for direction changes
export(float) var SPEED_DAMPENING_FACTOR = 3.0


func enterWithSpeed(entry_velocity:Vector2):
	enter()
	groundVelocity = entry_velocity
	owner.align_scene_x(groundVelocity)
	owner.get_node("AnimationPlayer").set_speed_scale(groundVelocity.x/TOP_RUN_SPEED)


# Initialize the state. E.g. change the animation
func enter():
	var input_direction = get_input_direction()
	#play animation and set to input direction via scale flip
	owner.get_node("AnimationPlayer").play("run")
	groundVelocity = Vector2(0,0)
	return
#
## Clean up the state. Reinitialize values like a timer
func exit():
	.exit()
#
func handle_input(event):
	.handle_input(event)
#
func update(delta):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	var speed = abs(groundVelocity.x)
	var input_Damp = abs(sign(input_direction.x) + sign(groundVelocity.x))

	
	#There are two top speeds- top run speed and overall moves speed
	#overall speed is immediately capped
	#top run speed is dampened down by friction and a dampening factor chosen in the editor
	#The dampening is increased if the input direction is opposite the current run direction
	
	#input_Damp serves to split the outcomes into three case- one where the player input and direction align(2),
	#one where the player is not pressing anything but still moving(1), 
	#and one where the player is trying to change direction (0)
	
	#this is the main x direction speed calculation
	if speed > TOP_GROUND_SPEED:
		speed = TOP_GROUND_SPEED
	elif speed > TOP_RUN_SPEED:
		if input_Damp != 2:
			speed -= GROUND_FRICTION*delta*(2-input_Damp)*SPEED_DAMPENING_FACTOR
		else:
			speed -= GROUND_FRICTION*delta
	elif speed <= TOP_RUN_SPEED:
		if TOP_RUN_SPEED-speed < RUNNING_ACCELERATION*delta and input_Damp == 2:
			speed = TOP_RUN_SPEED
		elif speed != 0:
			speed += ((input_Damp-1)*RUNNING_ACCELERATION - GROUND_FRICTION * (2-input_Damp))*delta
			if speed < GROUND_FRICTION*delta and input_Damp == 1:
				speed = 0.0
				emit_signal("finished","idle")
		else:
			speed += RUNNING_ACCELERATION*delta
	
	#put the speed variable back into ground velocity, with direction
	if groundVelocity.x != 0:
		groundVelocity.x = sign(groundVelocity.x)*speed
	else:
		groundVelocity.x = sign(input_direction.x)*speed
	
	groundVelocity = owner.move_and_slide(groundVelocity)
	update_look_direction(groundVelocity)
	
	#print(groundVelocity)
	
	
	owner.align_scene_x(groundVelocity)
	var anim_player = owner.get_node("AnimationPlayer")
	anim_player.set_speed_scale(groundVelocity.x/TOP_RUN_SPEED)
	
	.update(delta)

