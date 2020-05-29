extends Label


func _ready() -> void:
	GLB_events_bus.connect("map_count_updated", self, "_on_map_count_updated")


func _on_map_count_updated(count):
	text = str(count)