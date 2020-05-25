extends Timer

var can_land = true

func _on_Raycasts_ungrounded():
	if can_land == true:
		self.start()
		can_land = false
	pass # Replace with function body.

func _on_LandingLockout_timeout():
	can_land = true
