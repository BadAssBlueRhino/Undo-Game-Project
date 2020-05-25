extends State


func enter(_host):
	print("Locking: ", _host)
	_host._animation_player.play("Lock")


func exit(_host):
	# disconnect to movement signal in actor holding pen
	return

func handle_input(_host, _event):
	if _event.is_action_released("ui_lock"):
		_host._animation_player.play("release_lock")

func handle_key_event(_host, _key_event_string):
	if not _key_event_string == "Duplicate":
		return
	GLB_events_bus.emit_signal("duplicate_actor", _host, _host.actor_data.map_index.target)
	return "CoolDown"

func _on_animation_finished(_animation_name):
	if _animation_name == "release_lock":
		emit_signal("finished", "Idle")