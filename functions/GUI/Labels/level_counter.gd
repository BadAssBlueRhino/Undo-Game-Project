extends Label


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("map_count_updated", self, "_on_map_count_updated")


func _on_map_count_updated(count) -> void:
	text = str(count)