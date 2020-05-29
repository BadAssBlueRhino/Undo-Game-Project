extends Control


onready var win_popup = find_node("WinPopupPanel")


func _ready() -> void:
	GLB_events_bus.connect("level_won", self, "_on_level_won")
	GLB_events_bus.connect("gui_restart_pressed", self, "_on_gui_restart_pressed")


func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if _event.is_action_pressed("ui_restart"):
		if get_tree().paused == true:
			get_tree().paused = false
		GLB_events_bus.emit_signal("gui_restart_pressed")
	
	if _event.is_action_pressed("ui_accept") and get_tree().paused:
		print("You pressed: Enter")
		get_tree().paused = false
		GLB_events_bus.emit_signal("load_next_map")
		GLB_events_bus.emit_signal("gui_restart_pressed")


func _on_level_won():
	get_tree().paused = true
	win_popup.popup()


func _on_gui_restart_pressed():
	win_popup.visible = false