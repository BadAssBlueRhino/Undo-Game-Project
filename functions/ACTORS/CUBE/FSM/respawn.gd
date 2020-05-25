extends State


func enter(_host):
	print("Respawning: ", _host)
	_host._animation_player.play("Respawn")


func _on_animation_finished(_animation_name):
	if _animation_name == "Respawn":
		emit_signal("finished", "Idle")