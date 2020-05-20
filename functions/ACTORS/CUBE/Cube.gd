# Inherits from script named "class_cube.gd"
extends Cube

signal state_changed

var current_state = null
var previous_state
var STATES_MAP = {
		"idle" : $States/Idle,
		"move" : $States/Move,
		"bump" : $States/Bump,
		}

var states_data = {
		"current_state" : null,
		"previous_state" : 0
	}

var current_map_index
var current_world_position 
var requested_map_index
var map_index_log := []

func _ready() -> void:
	_tween = get_node("Tween")
	current_state = STATES_MAP["idle"]
	# _change_state("idle")

#func _physics_process(_delta: float) -> void:
#	var _new_state_name = current_state.update()
#	if _new_state_name:
#		_change_state(_new_state_name)

#func _input(_event: InputEvent) -> void:
#	# var _new_state_name = current_state.handle_input()
#	# if _new_state_name:
#	# 	_change_state(_new_state_name)
#	pass

func _change_state(_state_name):
	current_state.exit()
	current_state = STATES_MAP[_state_name]
	current_state.enter()
	emit_signal("state_changed", current_state.get_name())