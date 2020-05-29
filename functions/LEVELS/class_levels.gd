extends TileMap
class_name Levels

export var starting_map_index : Vector2

# Store a function reference.
var map_to_world_func = funcref(self, "_convert_map_to_world")

func _ready() -> void:
	if starting_map_index == Vector2():
		printerr("Starting indedx not assigned.")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("gui_restart_pressed", self, "_on_gui_restart_pressed")
	# warning-ignore:return_value_discarded
	GLB_events_bus.emit_signal("map_to_world_function", map_to_world_func)
	# warning-ignore:return_value_discarded
	GLB_events_bus.emit_signal("map_loaded", self)
	# warning-ignore:return_value_discarded
	GLB_events_bus.emit_signal("gui_restart_pressed")

func _on_gui_restart_pressed() -> void:
	print("Level reset.")
	GLB_events_bus.emit_signal("level_restarted", starting_map_index)

func get_valid_map_indexs() -> Array:
	return get_used_cells()

func _convert_map_to_world(_index):
	return map_to_world(_index) + position