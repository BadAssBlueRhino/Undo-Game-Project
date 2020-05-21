extends Node
# Make this into a node, and have the active chagned to "Can process intput"

var _is_active := true setget set_is_active

var _movement_started := false
var _movement_direction := Vector2()
var _undo_started := false
var _lock_started := false


func _init() -> void:
	var _movement_started := false
	var _movement_direction := Vector2()
	var _undo_started := false
	var _lock_started := false


func _process(_delta: float) -> void:
	var _input = Input
	
	if _input.is_action_pressed("ui_up"):
		_movement_direction = Vector2(0, -1)
	elif _input.is_action_pressed("ui_right"):
		_movement_direction = Vector2(1, 0)
	elif _input.is_action_pressed("ui_down"):
		_movement_direction = Vector2(0, 1)
	elif _input.is_action_pressed("ui_left"):
		_movement_direction = Vector2(-1, 0)
	
	if _movement_direction:
		_movement_started = true
		set_is_active(false)


func _input(_event: InputEvent) -> void:
	if _event.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if _event.is_action_just_pressed("ui_undo"):
		_undo_started = true
	elif _event.is_action_pressed("ui_lock"):
		_lock_started = true
	elif not _event.is_action_released("ui_lock"):
		_lock_started = false
	
	set_is_active(false)

func set_is_active(_value):
	_is_active = _value
	set_process(_value)
	set_process_input(_value)
	#set_block_signals(not _value)
	if _value == false:
		GLB_events_bus.emit_signal("actor_commands_started")