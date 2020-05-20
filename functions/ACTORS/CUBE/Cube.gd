extends KinematicBody2D

# warning-ignore:unused_signal
signal state_changed
signal map_index_changed

onready var _state_machine = $StateMachineNode

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

func _ready() -> void:
	if state.starting == null:
		push_error("ERROR: Actor starting state not assigned.")
	_state_machine._change_state(state.starting)

func _change_map_starting_index(_index):
	actor_data.map_index.starting = _index

func _change_starting_state(_state):
	state.starting = _state

# will get moved probalby to a state (moving)
func _change_map_index(_new_index):
	actor_data.map_index.history.append(actor_data.map_index.current)
	actor_data.map_index.current = _new_index
	emit_signal("map_index_changed", actor_data.map_index.current)