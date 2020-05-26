extends State

# Initialize the state. E.g. change the animation
func enter(_host):
	_host._animation_player.play("CoolDown")


func update(_host, _delta):
	if not Input.is_action_pressed("ui_lock"):
		_host._animation_player.play("release_lock")


func _on_animation_finished(_animation_name):
	if _animation_name == "release_lock":
		emit_signal("finished", "Idle")