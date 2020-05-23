extends State


func enter(_host):
	_host._animation_player.play("idle")


func handle_input(_host, _event):
	if _event.is_action_pressed("ui_lock"):
		return "lock"


func _on_animation_finished(_animation_name):
	return


func handle_key_event(_host, _key_event_string):
	if _key_event_string == "update_position":
		return "move"