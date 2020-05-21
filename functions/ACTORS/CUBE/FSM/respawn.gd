extends Node


signal finished(_next_state_name)


onready var _scene_parent = self.get_owner()

# Initialize the state. E.g. change the animation
func enter(_host):
	
	return

# Clean up the state. Reinitialize values like a timer
func exit(_host):
	return

func _on_animation_finished(_animation_name):
	_scene_parent.set_can_receive_input(true) #this is needed at the end of most states, like the ones that go to idle
	return