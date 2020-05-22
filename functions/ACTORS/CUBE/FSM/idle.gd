extends State

# signal finished(_next_state_name)

func enter(_host):
	_host._animation_player.play("idle")

func exit(_host):
	return

func handle_input(_host, _event):
	if _event == "update_position":
		_handle_movement()
		return "move"
	elif _event.is_action_pressed("ui_lock"):
		return "lock"

func update(_host, _delta):
	pass

func _on_animation_finished(_animation_name):
	return

func _handle_movement():
	print("Handling movement.")
	pass