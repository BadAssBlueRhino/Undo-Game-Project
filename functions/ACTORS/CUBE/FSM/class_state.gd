extends Node
class_name State

# warning-ignore:unused_signal
signal finished(_next_state_name)

# Initialize the state. E.g. change the animation
func enter(_host):
	return

# Clean up the state. Reinitialize values like a timer
func exit(_host):
	return

func handle_input(_host, _event):
	return

func update(_host, _delta):
	return

func handle_key_event(_host, _key_event_string):
	return

func _on_animation_finished(_animation_name):
	return