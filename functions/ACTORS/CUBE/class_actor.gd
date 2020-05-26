extends KinematicBody2D
class_name Actor


signal state_changed


# warning-ignore:unused_class_variable
var _animation_speed : float = 0.2 # Seconds

var actor_data = {
	"direction" : null,
	"map_index" : {
		"starting" : null,
		"current" : null,
		"target" : null,
		"can_add_to_history" : true,
		"history" : [],
		},
	"world_position" : null,
}

var state = {
	"can_receive" : true,
	"starting" : null, # Stored as string
	"current" : null, # Stored as a reference to a node
	"previous_stack" : [null,], # Stored as a reference to a node
}

# warning-ignore:unused_class_variable
onready var _animation_player = $AnimationPlayer
# warning-ignore:unused_class_variable
onready var _tween = $Tween
# warning-ignore:unused_class_variable
onready var _animated_sprite = $TextureNode/AnimatedTexture

onready var STATES_MAP = {
	"Respawn" :  $States/Respawn,
	"Idle" : $States/Idle,
	"Move" : $States/Move,
	"Bump" : $States/Bump,
	"Lock" : $States/Lock,
	"Duplicate" : $States/Duplicate,
	"CoolDown" : $States/CoolDown,
	"IdleDuplicate" : $States/IdleDuplicate,
}


func initalize_state(_starting_index, _target_index = null):
	var _starting_state_name
	if _target_index == null:
		_starting_state_name = "Respawn"
		actor_data.map_index.history.clear()
	elif not _target_index == null:
		_starting_state_name = "Duplicate"
		actor_data.map_index.target = _target_index
	
	actor_data.map_index.starting = _starting_index
	actor_data.map_index.current = _starting_index
	state.starting = _starting_state_name


func _process(_delta: float) -> void:
	update_z_index()
	state.current.update(self, _delta)


func update_z_index():
	if actor_data.map_index.current == null:
		return
	var x_component = -1 * actor_data.map_index.current.x
	var y_component = actor_data.map_index.current.y
	z_index = x_component + y_component


func get_current_state_name():
	return state.current.get_name()


func _change_state(_new_state_name):
	if not state.current == null:
		state.current.exit(self)
	
	if _new_state_name == "previous":
		state.previous_stack.pop_front()
	elif _new_state_name in ["Move",]:
		state.previous_stack.push_front(STATES_MAP[_new_state_name])
	else:
		var new_state = STATES_MAP[_new_state_name]
		state.previous_stack[0] = new_state

	state.current = state.previous_stack[0]
	if _new_state_name != "previous":
		state.current.enter(self)
	emit_signal("state_changed", state.previous_stack)


func _on_AnimationPlayer_animation_finished(animation_name: String) -> void:
	state.current._on_animation_finished(animation_name)