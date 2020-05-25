extends Timer


var jumpCoyote = false
var timerLockout = false
#onready var groundDetector1 = owner.get_node("GroundDetector1")
#onready var groundDetector2 = owner.get_node("GroundDetector2")

#func _process(delta):
#
#	pass

func _on_Coyote_timeout():
	jumpCoyote = false


func _on_Raycasts_ungrounded():
	jumpCoyote = true
	if timerLockout == false:
		timerLockout = true
		self.start()


func _on_Raycasts_landed():
	timerLockout = false
