extends State


func enter(_host):
	_host._animation_player.play("Idle")


func handle_input(_host, _event):
	if _event.is_action_pressed("ui_lock"):
		return "Lock"


func handle_key_event(_host, _key_event_string):
	if _key_event_string == "update_position":
		return "Move"