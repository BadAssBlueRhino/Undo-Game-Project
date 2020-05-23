extends State


func enter(_host):
	_host._animation_player.play("lock")


func exit(_host):
	# disconnect to movement signal in actor holding pen
	return

func handle_input(_host, _event):
	if _event.is_action_released("ui_lock"):
		_host._animation_player.play("release_lock")

func update(_host, _delta):
	return

func _on_animation_finished(_animation_name):
	if _animation_name == "release_lock":
		emit_signal("finished", "idle")