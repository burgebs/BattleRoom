extends "res://src/state machine/state_machine.gd"
#state implementation versions:
#mach 1- running, jumping, idle, falling
#mach 2- dash, hitlock
#mach 3- crouch, wall cling, slide

#things to keep track of for all states (particularly interrupt states- dash, cast, hitlock):
#nothing in mach 1
#mach 2: number of dashes used- 1 dash until on_ground or on_wall inherited state
#cast cooldowns (timers)
export(int) var NUMBER_OF_DASHES = 1

var remaining_dashes = NUMBER_OF_DASHES
var carryover_velocity = Vector2(0.0,0.0)
#state_machine variables:
#signal state_changed(current_state)
#export(NodePath) var START_STATE
#var states_map = {}
#var states_stack = []
#var current_state = null
#var _active = false setget set_active
#
func _ready():
	states_map = {
		"idle": $Idle,
		"running": $Running,
		"jumping": $Jumping,
		"falling": $Falling,
		"dashing": $Dashing,
		"hitlocked": $Hitlocked
	}

#special state interactions go here
#to do:
#conserve x velocity between basic movement states. y velocity is reset
func _change_state(state_name):
	carryover_velocity = current_state.get_velocity()
	if not _active:
		return
	if state_name in ["running","jumping","falling","dashing"]:
		states_stack.push_front(states_map[state_name])
	if state_name in ["idle"]:
		states_stack.clear()
		states_stack.push_front(states_map["idle"])
	
	._change_state(state_name)
	
	if current_state in ["idle","running","jumping","falling"]:
		carryover_velocity.y = 0.0
		current_state.add_velocity(carryover_velocity)


func _input(event):
	print(remaining_dashes)
	print (event.is_action_pressed("dash"))
	if !(event.is_action_pressed("dash") and remaining_dashes <= 0):
		current_state.handle_input(event)
		
	#jumping is allowed from any state if the buffer and coyote timers are satisfied
	#if a state wants to explicitly block jumping, it should eat the event with action_release("jump")
	if event.is_action_pressed("jump") and $JumpBuffer.jumpBuffered and $Coyote.jumpCoyote and current_state != $Jumping:
		_change_state("jumping")

func _physics_process(delta):
	pass

func on_grounded_state():
	remaining_dashes = NUMBER_OF_DASHES

func _on_Dashing_used():
	remaining_dashes -= remaining_dashes
