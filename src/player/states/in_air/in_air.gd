extends "res://src/state machine/state.gd"


#MAX SPEED means overall speed limit. SPEED CAP means top speed attainable by regular player acceleration
export(float) var GRAVITY = 600.0
export(float) var MAX_X_SPEED = 800.0
export(float) var SPEED_CAP_X = 600.0
export(float) var MAX_Y_SPEED = 1400.0
export(float) var SPEED_CAP_Y = 1200.0
#air acceleration doubles for air friction
export(float) var AIR_ACCELERATION = 60.0

export(float) var X_SPEED_DAMPENING_FACTOR = 3.0
export(float) var Y_SPEED_DAMPENING_FACTOR = 3.0

var can_land = true
var landed = false

var airVelocity = Vector2(0.0,0.0)

func _ready():
# warning-ignore:return_value_discarded
	owner.get_node("Raycasts").connect("landed",self,"_on_raycasts_landed")
# warning-ignore:return_value_discarded
	owner.get_node("Player State Machine/LandingLockout").connect("timeout",self,"_on_landinglockout_timeout")
	landed = false
	return

# Initialize the state. E.g. change the animation
func enter():
	can_land = false
	airVelocity = Vector2(airVelocity.x,airVelocity.y)
	return
#
## Clean up the state. Reinitialize values like a timer
func exit():
	airVelocity = Vector2(0.0,0.0)
#
func handle_input(event):
	if event.is_action_pressed("dash"):
		print("dashing from air")
		emit_signal("finished","dashing")

func get_velocity():
	return airVelocity
	
func add_velocity(vel:Vector2):
	airVelocity += vel

func update(delta):
	
	var x_speed = abs(airVelocity.x)
	var y_speed = abs(airVelocity.y)
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	var x_input_Damp = abs(sign(input_direction.x) + sign(airVelocity.x))
	
	#print(str(airVelocity) + " is air velocity before calculation. " + str(x_input_Damp) + " is x input damp")
	#x speed calc
	if x_speed > MAX_X_SPEED:
		x_speed = MAX_X_SPEED
	elif x_speed > SPEED_CAP_X:
		if x_input_Damp != 2:
			x_speed -= AIR_ACCELERATION*delta*(2-x_input_Damp)*X_SPEED_DAMPENING_FACTOR
		else:
			x_speed -= AIR_ACCELERATION*delta
	elif x_speed <= SPEED_CAP_X:
		if SPEED_CAP_X-x_speed < AIR_ACCELERATION*delta and x_input_Damp == 2:
			x_speed = SPEED_CAP_X
		elif x_speed != 0:
			x_speed += ((x_input_Damp-1)*AIR_ACCELERATION+(x_input_Damp-2)\
				*AIR_ACCELERATION*X_SPEED_DAMPENING_FACTOR)*delta
			if x_speed < AIR_ACCELERATION*delta and x_input_Damp == 1:
				x_speed = 0.0
		else:
			x_speed += AIR_ACCELERATION*delta
	#y speed calc
	if y_speed > MAX_Y_SPEED:
		y_speed = MAX_Y_SPEED
	elif y_speed > SPEED_CAP_Y:
		y_speed -= (AIR_ACCELERATION+GRAVITY)*delta
	elif y_speed <= SPEED_CAP_Y and airVelocity.y >= 0: #falling
		if SPEED_CAP_Y-y_speed < GRAVITY*delta:
			y_speed = SPEED_CAP_Y
		else:
			y_speed += GRAVITY *delta
	elif y_speed <= SPEED_CAP_Y and airVelocity.y < 0: #rising
		y_speed -= GRAVITY*delta
	
	if airVelocity.x != 0:
		airVelocity.x = sign(airVelocity.x)*x_speed
	else:
		airVelocity.x = sign(input_direction.x)*x_speed
	
	if airVelocity.y != 0:
		airVelocity.y = sign(airVelocity.y)*y_speed
	else:
		airVelocity.y += y_speed
	
	#print(str(airVelocity) + " is air velocity after calculation but before move and slide")
	airVelocity = owner.move_and_slide(airVelocity,Vector2.UP)
	#print(str(airVelocity) + " is air velocity after calculation")
	
	owner.align_scene_x(airVelocity)

func _on_raycasts_landed():
	if can_land:
		if airVelocity.x != 0:
			emit_signal("finished","running")
		else:
			emit_signal("finished","idle")

func _on_landinglockout_timeout():
	can_land = true
#func _on_animation_finished(anim_name):
#	return
