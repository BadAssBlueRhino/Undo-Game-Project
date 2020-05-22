extends KinematicBody2D


# warning-ignore:unused_signal
signal state_changed
# warning-ignore:unused_signal
signal map_index_changed


var _world_position_function

var actor_data = {
	"map_index" : {
		"starting" : null,
		"current" : null,
		"target" : null,
		"history" : [],
		},
	"world_position" : null,
}

var state = {
	"starting" : null, # Stored as string
	"current" : null, # Stored as a reference to a node
	"previous" : null, # Stored as a reference to a node
}

onready var _animation_player = $AnimationPlayer
onready var _tween = $Tween

onready var STATES_MAP = {
	"respawn" :  $States/Respawn,
	"idle" : $States/Idle,
	"move" : $States/Move,
	"bump" : $States/Bump,
	"lock" : $States/Lock,
	"duplicate" : $States/Duplicate,
	"cool_down" : $States/CoolDown,
}

func initalize_state(_starting_index, _target_index = null):
	var _starting_state_name
	if _target_index == null:
		_starting_state_name = "respawn"
		state.starting = _starting_state_name
		actor_data.map_index.starting = _starting_index
		actor_data.map_index.current = _starting_index
	elif not _target_index == null:
		_starting_state_name = "duplicate"

func _ready() -> void:
	actor_data.world_position = get_world_position(actor_data.map_index.starting)
	position = actor_data.world_position
	# visible = true
	for state_node in $States.get_children():
		state_node.connect("finished", self, "_change_state")
	if state.starting == null:
		push_error("ERROR: Actor starting index not initalized.")
	_change_state(state.starting)

# Call stored function reference.
func get_world_position(_index) -> Vector2:
	return _world_position_function.call_func(_index)

func get_current_state_name():
	return state.current.get_name()


func _input(_event: InputEvent) -> void:
	if not _event.is_action("ui_lock"):
		return
	var _new_state_name = state.current.handle_input(self, _event)
	if _new_state_name:
		_change_state(_new_state_name)


func _process_movement(_direction_vector):
	actor_data.map_index.target = actor_data.map_index.current + _direction_vector
	var _new_state_name = state.current.handle_input(self, "update_position")
	if _new_state_name:
		_change_state(_new_state_name)


func _process_duplication():
	var _new_state_name = state.current.handle_input(self, "duplicate")
	if _new_state_name:
		_change_state(_new_state_name)


func _change_state(_new_state_name):
	if not state.current == null:
		state.current.exit(self)
		state.previous  = state.current
	state.current = STATES_MAP[_new_state_name]
	state.current.enter(self)
	emit_signal("state_changed", state.current.get_name())


func _on_AnimationPlayer_animation_finished(animation_name: String) -> void:
	state.current._on_animation_finished(animation_name)


# -----

# Need to work on the Tween and where to call map_to_world, and update the position.
# Work on all the states moving forward.


# will get moved probalby to a state (moving)
func _change_map_index(_new_index):
	actor_data.map_index.history.append(actor_data.map_index.current)
	actor_data.map_index.current = _new_index
	emit_signal("map_index_changed", actor_data.map_index.current)

