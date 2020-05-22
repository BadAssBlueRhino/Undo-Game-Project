extends State

# signal finished(_next_state_name)

# Initialize the state. E.g. change the animation
func enter(_host):
	# connect to movement signal in actor holding pen
	return

# Clean up the state. Reinitialize values like a timer
func exit(_host):
	# disconnect to movement signal in actor holding pen
	return

func handle_input(_host, _event):
	if _event.is_action_released("ui_lock"):
		return "idle"

func update(_host, _delta):
	return

func _on_animation_finished(_animation_name):
	return