extends Node
class_name FiniteStateMachine

var _state = null setget set_state
var _previous_state = null
var _states = {}

onready var _parent = get_parent()

func _physics_process(_delta: float) -> void:
	if _state == null:
		return
	_state_logic(_delta)
	var _transition = _get_transition(_delta)
	if _transition == null:
		return
	set_state(_transition)

func set_state(_new_state) -> void:
	_previous_state = _state
	_state = _new_state
	
	if _previous_state != null:
		_exit_state(_previous_state, _new_state)
	
	if _new_state != null:
		_enter_state(_new_state, _previous_state)

func add_state(_state_name) -> void:
	_states[_state_name] = _states.size()

func _state_logic(_delta) -> void:
	pass

func _get_transition(_delta):
	return null

func _enter_state(_new_state, _old_state) ->void:
	pass

func _exit_state(_old_state, _new_state) -> void:
	pass