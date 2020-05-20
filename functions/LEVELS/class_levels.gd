extends TileMap
class_name Levels

export var starting_map_index : Vector2

onready var _cell_list : Array = get_used_cells()
var _cell_list_occupied : Array

func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("actor_index_update_requested", self, "_on_actor_index_update_requested")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("gui_restart_pressed", self, "_on_gui_restart_pressed")

func _on_gui_restart_pressed():
	print("Level reset.")
	GLB_events_bus.emit_signal("level_restarted", starting_map_index)

func _can_move_to_cell(_index):
	if not is_cell_valid(_index) or not is_cell_vacant(_index):
		return false
	return true

func is_cell_valid(_index):
	if not _cell_list.has(_index):
		print("Cell space is invalid")
		return false
	return true

func is_cell_vacant(_index):
	if _cell_list_occupied.has(_index):
		print("Cell space is occupied")
		return false
	return true

func _on_actor_index_update_requested(_actor, _current_index, _new_index):
	if not _can_move_to_cell(_new_index):
		_actor.clear_groups()
		return
	if not _current_index == null:
		_cell_list_occupied.erase(_current_index)
	_cell_list_occupied.append(_new_index)
	var _new_position = self.map_to_world(_new_index)
	GLB_events_bus.emit_signal("actor_index_update_granted", _actor, _new_position)