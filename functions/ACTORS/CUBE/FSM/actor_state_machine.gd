extends Node

onready var _actor := self.get_owner()

onready var STATES_MAP = {
		"respawn" : $States/Respawn,
		"idle" : $States/Idle,
		"move" : $States/Move,
		"bump" : $States/Bump,
		"lock" : $States/Lock,
		"duplicate" : $States/Duplicate,
		"cool_down" : $States/CoolDown,
		}

func _physics_process(_delta : float) -> void:
	var _new_state = STATES_MAP[_actor.state.current].update()
	if _new_state:
		_change_state(_new_state)

func _input(_event : InputEvent) -> void:
	var _new_state = STATES_MAP[_actor.state.current].handle_input()
	if _new_state:
		_change_state(_new_state)
	pass

func _change_state(_new_state):
	if not _actor.state.current == null:
		STATES_MAP[_actor.state.current].exit(_actor)
		_actor.state.previous  = _actor.state.current
	_actor.state.current = _new_state
	STATES_MAP[_actor.state.current].enter(_actor)
	_actor.emit_signal("state_changed", _actor.state.current)