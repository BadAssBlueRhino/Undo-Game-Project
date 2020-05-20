extends Node


func _process(_delta) -> void:
	var _input = Input
	var _input_direction := Vector2()
	if _input.is_action_pressed("ui_up"):
		_input_direction = Vector2(0, -1)
	elif _input.is_action_pressed("ui_right"):
		_input_direction = Vector2(1, 0)
	elif _input.is_action_pressed("ui_down"):
		_input_direction = Vector2(0, 1)
	elif _input.is_action_pressed("ui_left"):
		_input_direction = Vector2(-1, 0)
	
	if not _input_direction == null:
		GLB_events_bus.emit_signal("input_directed", _input_direction)


func _input(_event: InputEvent) -> void:
	if _event.is_action_just_pressed("ui_undo"):
		GLB_events_bus.emit_signal("undo_signaled")
	elif _event.is_action_pressed("ui_lock"):
		GLB_events_bus.emit_signal("lock_started")
	elif not _event.is_action_released("ui_lock"):
		GLB_events_bus.emit_signal("lock_finished")
	elif _event.is_action_just_pressed("ui_cancel"):
		get_tree().quit()