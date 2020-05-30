extends Label

var move_counter : int

func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("actors_moved", self, "_on_actors_moved")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("gui_restart_pressed", self, "_on_gui_restart_pressed")


func _on_gui_restart_pressed() -> void:
	move_counter = 0
	text = str(move_counter)


func _on_actors_moved():
	move_counter += 1
	text = str(move_counter)