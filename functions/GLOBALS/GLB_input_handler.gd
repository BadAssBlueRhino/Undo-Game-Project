extends Node

var _undo_action_map = "ui_keys_undo" setget , get_undo_action_map
#var up_action_map = 
var right_action_map = "ui_right"
var down_action_map = "ui_down"
var left_action_map = "ui_left"

onready var _direction_actions = [
		"ui_up", 
		right_action_map, 
		down_action_map, 
		left_action_map] setget , get_direction_actions

func get_undo_action_map():
	return _undo_action_map

func get_direction_actions():
	return _direction_actions

func _process(_delta) -> void:
	var _event = Input
	var _direction = null
	if _event.is_action_pressed("ui_up"):
		_direction = "up"
	elif _event.is_action_pressed("ui_right"):
		_direction = "right"
	elif _event.is_action_pressed("ui_down"):
		_direction = "down"
	elif _event.is_action_pressed("ui_left"):
		_direction = "left"
	
	if not _direction == null:
		GLB_events_bus.emit_signal("direction_key_pressed", _direction)

func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("ui_group_trigger"):
		GLB_events_bus.emit_signal("trigger_locked_group", true)
	elif not _event.is_action_pressed("ui_group_trigger"):
		GLB_events_bus.emit_signal("trigger_locked_group", false)
	if _event.is_action_pressed("ui_keys_undo") and not _event.is_echo():
		GLB_events_bus.emit_signal("undo_action_signaled")
	elif _event.is_action_pressed("ui_cancel") and not _event.is_echo():
		get_tree().quit()