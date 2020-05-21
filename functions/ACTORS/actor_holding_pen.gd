extends Node

var _all_actors : Array setget , get_all_actors


func _init() -> void:
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	_all_actors.clear()


func _ready() -> void:
	GLB_events_bus.connect("actor_commands_started", self, "_on_actor_commands_started")


func get_all_actors():
	return _all_actors


func _on_actor_commands_started():
	set_process(true)


func _process(_delta: float) -> void:
	for _actor in _all_actors.size():
		if not _actor.can_receive_input():
			return
	GLB_events_bus.emit_signal("actor_commands_finished")
	set_process(false)