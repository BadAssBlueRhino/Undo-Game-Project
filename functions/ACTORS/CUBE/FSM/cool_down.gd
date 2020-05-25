extends State

# Initialize the state. E.g. change the animation
func enter(_host):
	_host._animation_player.play("CoolDown")


func handle_input(_host, _event):
	if _event.is_action_released("ui_lock"):
		_host._animation_player.play("release_lock")


func _on_animation_finished(_animation_name):
	if _animation_name == "release_lock":
		emit_signal("finished", "Idle")