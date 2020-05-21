extends KinematicBody2D


# warning-ignore:unused_signal
signal state_changed
# warning-ignore:unused_signal
signal map_index_changed


var actor_data = {
	"map_index" : {
		"staring" : null,
		"current" : null,
		"target" : null,
		},
	"history" : [],
	"world_position" : null,
}

# This holds a reference to the node, not the string
var state = {
	"starting" : null,
	"current" : null,
	"previous" : null,
}

onready var STATES_MAP = {
	"respawn" : $States/Respawn,
	"idle" : $States/Idle,
	"move" : $States/Move,
	"bump" : $States/Bump,
	"lock" : $States/Lock,
	"duplicate" : $States/Duplicate,
	"cool_down" : $States/CoolDown,
}

onready var _animation_hub = $ActorAnimationHub


func respawn(_starting_index):
	actor_data.map_index.starting = _starting_index
	state.starting = STATES_MAP["respawn"]


func _ready() -> void:
	if actor_data.map_index.starting == null or state.starting == null:
		push_error("ERROR: Actor starting state not initalized.")
	_change_state(state.starting)


func _physics_process(_delta : float) -> void:
	var _new_state = state.current.update(self, _delta)
	if _new_state:
		_change_state(_new_state)


func _input(_event : InputEvent) -> void:
	var _new_state_name = state.current.handle_input(self, _event)
	if _new_state_name:
		_change_state(_new_state_name)


func _on_ActorAnimationHub_animation_finished(animation_name) -> void:
	state.current._on_animation_finished(animation_name)


func _change_state(_new_state_name):
	if not state.current == null:
		STATES_MAP[state.current].exit(self)
		state.previous  = state.current
	state.current = STATES_MAP[_new_state_name]
	state.current.enter(self)
	emit_signal("state_changed", state.current)

# -----

func initalize_duplication(_index, _target_index):
	actor_data.map_index.current = _index
	actor_data.map_index.target = _target_index


# will get moved probalby to a state (moving)
func _change_map_index(_new_index):
	actor_data.map_index.history.append(actor_data.map_index.current)
	actor_data.map_index.current = _new_index
	emit_signal("map_index_changed", actor_data.map_index.current)