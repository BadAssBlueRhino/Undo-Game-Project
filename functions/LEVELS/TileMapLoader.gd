extends Node

var vaild_map_indexs := []

func load_map(_map_path):
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	var _map = _map_path.instance()
	self.add_child(_map)
	_map._on_gui_restart_pressed()
	vaild_map_indexs = _map.get_valid_map_indexs()

func is_index_valid(_index):
	if not vaild_map_indexs.has(_index):
		return false
	return true