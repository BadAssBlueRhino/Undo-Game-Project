extends TileMap
class_name Levels

export var starting_map_index : Vector2

func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("gui_restart_pressed", self, "_on_gui_restart_pressed")

func _on_gui_restart_pressed() -> void:
	print("Level reset.")
	GLB_events_bus.emit_signal("level_restarted", starting_map_index)

func get_valid_map_indexs() -> Array:
	return get_used_cells()