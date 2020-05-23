extends Node


var vaild_map_indexs := []
var _loaded_map


func _ready() -> void:
# warning-ignore:return_value_discarded
	GLB_events_bus.connect("map_loaded", self, "_on_map_loaded")


func load_map(_map_path):
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	var _map = _map_path.instance()
	self.add_child(_map)


func _on_map_loaded(_map_object):
	_loaded_map = _map_object
	vaild_map_indexs = _loaded_map.get_valid_map_indexs()
	_loaded_map._on_gui_restart_pressed()


func is_index_valid(_index):
	if not vaild_map_indexs.has(_index):
		return false
	return true