extends State


func enter(_host):
	_host._animation_player.play("IdleDuplicate")


func update(_host, _delta):
	if not Input.is_action_pressed("ui_lock"):
		_host._animation_player.play("release_lock")


func handle_key_event(_host, _key_event_string):
	if not _key_event_string == "Undo":
		return
	return "Move"


func _on_animation_finished(_animation_name):
	if _animation_name == "release_lock":
		emit_signal("finished", "Idle")