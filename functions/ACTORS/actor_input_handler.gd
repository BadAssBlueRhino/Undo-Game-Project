extends Node
# Make this into a node, and have the active chagned to "Can process intput"

var _can_process_input := true setget set_can_process_input

onready var _command_node = $ActorCommand

func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("actor_commands_finished", self, "_on_actor_commands_finished")

# Reset the actor command variables
func _on_actor_commands_finished():
	_command_node._init()
	set_can_process_input(true)

func _process(_delta: float) -> void:
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
		set_can_process_input(false)


func _input(_event: InputEvent) -> void:
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

func set_can_process_input(_value):
	_can_process_input = _value
	set_process(_value)
	set_process_input(_value)
	#set_block_signals(not _value)
	if _value == false:
		GLB_events_bus.emit_signal("actor_commands_started")