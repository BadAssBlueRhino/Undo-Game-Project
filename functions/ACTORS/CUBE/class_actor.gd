extends KinematicBody2D
class_name Actor


signal state_changed


# warning-ignore:unused_class_variable
var _animation_speed : float = 0.2 # seconds

var actor_data = {
	"direction" : null,
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

# warning-ignore:unused_class_variable
onready var _animation_player = $AnimationPlayer
# warning-ignore:unused_class_variable
onready var _tween = $Tween
# warning-ignore:unused_class_variable
onready var _animated_sprite = $TextureNode/AnimatedTexture

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
		actor_data.map_index.starting = _starting_index # could technically just be in histroy.
		actor_data.map_index.current = _starting_index
		actor_data.map_index.history.append(_starting_index)
	elif not _target_index == null:
		_starting_state_name = "duplicate"


func get_current_state_name():
	return state.current.get_name()


func _change_state(_new_state_name):
	if not state.current == null:
		state.current.exit(self)
		state.previous  = state.current
	state.current = STATES_MAP[_new_state_name]
	state.current.enter(self)
	emit_signal("state_changed", state.current.get_name())


func _on_AnimationPlayer_animation_finished(animation_name: String) -> void:
	state.current._on_animation_finished(animation_name)