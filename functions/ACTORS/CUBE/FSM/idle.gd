extends State

signal finished(_next_state_name)

# Initialize the state. E.g. change the animation
func enter(_host):
	_host.get_node("ActorAnimationHub").start_animation("idle")

# Clean up the state. Reinitialize values like a timer
func exit(_host):
	return

func handle_input(_host, _event):
	var _event_processed := false
	
	if _event.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if _event.is_action_just_pressed("ui_undo"):
		GLB_events_bus.emit_signal("undo_started")
		_event_processed = true
	elif _event.is_action_pressed("ui_lock"):
		GLB_events_bus.emit_signal("_lock_started", true)
		_command_node._lock_started = true
		_event_processed = true
	elif not _event.is_action_released("ui_lock"):
		GLB_events_bus.emit_signal("_lock_started", false)
		_event_processed = true
	
	if _event_processed:
		set_can_process_input(false)

func update(_host, _delta):
	var _input := Input
	var _direction := Vector2()
	if _input.is_action_pressed("ui_up"):
		_direction = Vector2(0, -1)
	elif _input.is_action_pressed("ui_right"):
		_direction = Vector2(1, 0)
	elif _input.is_action_pressed("ui_down"):
		_direction = Vector2(0, 1)
	elif _input.is_action_pressed("ui_left"):
		_direction = Vector2(-1, 0)
	
	if not _direction == Vector2():
		GLB_events_bus.emit_signal("actor_directions", _direction)

func _on_animation_finished(_animation_name):
	return