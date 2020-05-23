extends State


func enter(_host):
	print("Respawning: ", _host)
	_host._animation_player.play("respawn")


func _on_animation_finished(_animation_name):
	if _animation_name == "respawn":
		emit_signal("finished", "idle")