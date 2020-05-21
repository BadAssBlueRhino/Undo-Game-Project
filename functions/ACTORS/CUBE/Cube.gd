extends KinematicBody2D


# warning-ignore:unused_signal
signal state_changed
signal map_index_changed


var _can_receive_input := true setget set_can_receive_input, can_receive_input

var actor_data = {
		"map_index" : {
				"staring" : null,
				"current" : null,
				# "requested" : null,
				"history" : [],
				},
		"world_position" : null,
		}

var state = {
		"starting" : null,
		"current" : null,
		"previous" : null,
		}

onready var _state_machine = $StateMachineNode


func _ready() -> void:
	GLB_events_bus.connect("actor_commands_started", self, "_on_actor_commands_started")
	if state.starting == null:
		push_error("ERROR: Actor starting state not assigned.")
	_state_machine._change_state(state.starting)


func _on_actor_commands_started():
	_can_receive_input = false

func set_can_receive_input(_value):
	_can_receive_input = _value

func can_receive_input():
	return _can_receive_input


func _change_map_starting_index(_index):
	actor_data.map_index.starting = _index


func _change_starting_state(_state):
	state.starting = _state


# will get moved probalby to a state (moving)
func _change_map_index(_new_index):
	actor_data.map_index.history.append(actor_data.map_index.current)
	actor_data.map_index.current = _new_index
	emit_signal("map_index_changed", actor_data.map_index.current)