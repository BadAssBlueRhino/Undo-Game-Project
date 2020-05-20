extends FiniteStateMachine

func _ready() -> void:
	add_state("idle")
	add_state("lock")
	add_state("move")
	add_state("bump")
	add_state("duplicate")
	add_state("cool_down")
	call_deferred("set_state", _states.idle)

func _state_logic(_delta) -> void:
	if _state != _states.lock and _parent._should_lock():
		_parent.lock()
	pass

func _get_transition(_delta):
	match _state:
		_states.idle:
			if _parent._should_lock():
				return _states.lock
			elif _parent._should_move():
				return _states.move
		_states.lock:
			if not _parent._shoud_lock():
				return _states.idle
			elif _parent._should_duplicate():
				return _states.duplicate
		_states.move:
			if _parent._should_bump():
				return _states.bump
			elif _parent._should_idle():
				return _states.idle
		_states.bump:
			if not _parent._should_bump():
				return _states.idle
		_states.duplicate:
			if _parent._should_bump():
				return _states.bump
			elif _parent._should_cool_down():
				return _states.cool_down
		_states.cool_down:
			if not _parent._should_cool_down():
				return _states.idle
	return null

#func _enter_state(_new_state, _old_state) ->void:
#	match _new_state:
#		_states.idle:
#			_parent.Tween._play_animation("idle")
#	pass

func _exit_state(_old_state, _new_state) -> void:
	pass