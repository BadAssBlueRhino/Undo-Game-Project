extends Node

func load_map(_map_path):
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	var _map = _map_path.instance()
	self.add_child(_map)
	_map._on_gui_restart_pressed()