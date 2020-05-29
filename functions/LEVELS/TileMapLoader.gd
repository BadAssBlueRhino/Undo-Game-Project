extends Node


var current_level : int
var level_list := [
	"res://functions/LEVELS/Tile_Maps/Tile_Map_1.tscn",
	"res://functions/LEVELS/Tile_Maps/Tile_Map_2.tscn",
	"res://functions/LEVELS/Tile_Maps/Tile_Map_4.tscn",
	"res://functions/LEVELS/Tile_Maps/Tile_Map_5.tscn",
]


var vaild_map_indexs := []
var end_goal_indexs := []
var end_goal_tile_index := 2
var _loaded_map


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("map_loaded", self, "_on_map_loaded")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("load_next_map", self, "_on_load_next_map")


func load_starting_map():
	current_level = 0
	load_map(level_list[current_level])


func _on_load_next_map():
	current_level += 1
	if current_level >= level_list.size():
		return
	load_map(level_list[current_level])
	GLB_events_bus.emit_signal("map_count_updated", current_level)


func load_map(_map_path):
	var _loaded_map = load(_map_path)
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	var _map_child = _loaded_map.instance()
	add_child(_map_child)
	# GLB_events_bus.emit_signal("gui_restart_pressed")


func _on_map_loaded(_map_object):
	_loaded_map = _map_object
	vaild_map_indexs = _loaded_map.get_valid_map_indexs()
	end_goal_indexs = _loaded_map.get_used_cells_by_id(end_goal_tile_index)
	# GLB_events_bus.emit_signal("gui_restart_pressed")


func is_index_valid(_index):
	if not vaild_map_indexs.has(_index):
		return false
	return true