extends State


signal finished(_next_state_name)


func enter(_host):
	_host.get_node("ActorAnimationHub").start_animation("respawn")


func _on_animation_finished(_animation_name):
	if _animation_name == "respawn":
		emit_signal("finished", "idle")