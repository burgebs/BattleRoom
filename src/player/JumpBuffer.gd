extends Timer

var jumpBuffered = false

func _input(event):
	if event.is_action_pressed("jump") and self.is_stopped():
		jumpBuffered = true
		self.start()

func _on_JumpBuffer_timeout():
	jumpBuffered = false
