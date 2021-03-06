extends Node


var _all_actors := []
var _map_to_world_func

onready var _map_loader = get_node("../../TileMapLoader")


func _init() -> void:
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	_all_actors.clear()


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("map_to_world_function", self, "_on_map_to_world_function")


func _on_map_to_world_function(_map_func):
	_map_to_world_func = _map_func


func add_actor(_actor) -> void:
	var _starting_index = _actor.actor_data.map_index.starting
	_all_actors.append(_actor) # can add crrent state as well, may reomve duplciate code belwo , _current_index])
	_actor._world_position_function = _map_to_world_func
	add_child(_actor)


func _physics_process(_delta: float) -> void:
	if not can_actors_receive_input():
		return
	
	var _event := Input
	var _direction_vector := Vector2()
	
	if _event.is_action_pressed("ui_lock"):
		for _actor in _all_actors:
			_actor._input(_event)
	
	if _event.is_action_pressed("ui_up"):
		_direction_vector = Vector2(0, -1)
	if _event.is_action_pressed("ui_right"):
		_direction_vector = Vector2(1, 0)
	if _event.is_action_pressed("ui_down"):
		_direction_vector = Vector2(0, 1)
	if _event.is_action_pressed("ui_left"):
		_direction_vector = Vector2(-1, 0)
	
	if _direction_vector == Vector2():
		return
	
	if not _check_movement("Idle", _direction_vector):
		return
	
	for _actor in _all_actors:
		_actor._process_movement(_direction_vector)


func can_actors_receive_input():
	for _actor in _all_actors:
		if _actor.state.can_receive == false:
			return false
	return true


func _input(_event: InputEvent) -> void:
	if not can_actors_receive_input():
		return
	
	if _event.is_action_pressed("ui_undo"):
		if _check_movement("Lock"):
			for _actor in _all_actors.size():
				_all_actors[_actor]._process_duplication()
		elif _check_movement("IdleDuplicate"):
			for _actor in _all_actors.size():
				print("Process undo.")
				_all_actors[_actor]._process_undo()


func _check_movement(_event, _vector = null) -> bool:
	var _event_actors = _get_event_actors(_event)
	
	if _event_actors.size() == 0:
		return false
	
	if not _check_if_valid(_event, _vector, _event_actors):
		return false
	
	if _event in ["Lock"]:
		if not _check_event_specific_conflicts(_event_actors):
			return false
	
	if not _check_if_conflict(_event_actors):
		return false
	
	GLB_events_bus.emit_signal("actors_moved")
	return true


func _get_event_actors(_event) -> Array:
	var _actors_array := []
	for _actor in _all_actors:
		if _actor.get_current_state_name() == _event:
			_actors_array.append(_actor)
	return _actors_array


func _check_if_valid(_event, _vector, _event_actors):
	var _new_target_index
	for _event_actor in _event_actors:
		if _event in ["Lock", "IdleDuplicate"]:
			if not _event_actor.actor_data.map_index.history.size() == 0:
				_new_target_index = _event_actor.actor_data.map_index.history[0]
		elif _event in ["Idle"]:
			_new_target_index = _event_actor.actor_data.map_index.current + _vector
		
		if not _map_loader.is_index_valid(_new_target_index):
			return false
		_event_actor.actor_data.map_index.target = _new_target_index
		_get_target_direction(_event_actor, _new_target_index)
	return true


func _check_event_specific_conflicts(_event_actors):
	for _event_actor in _event_actors:
		for _actor in _all_actors:
			if _event_actors.has(_actor) and (not _actor == _event_actor):
				if _event_actor.actor_data.map_index.target == _actor.actor_data.map_index.current:
					return false
	return true


func _get_target_direction(_host, _host_target_index):
	var _host_current_index = _host.actor_data.map_index.current
	var _target_direction : String
	if not _host_current_index.x == _host_target_index.x:
		if _host_current_index.x < _host_target_index.x:
			_target_direction = "ui_right"
		else:
			_target_direction = "ui_left"
	
	elif not _host_current_index.y == _host_target_index.y:
		if _host_current_index.y < _host_target_index.y:
			_target_direction = "ui_down"
		else:
			_target_direction = "ui_up"
	
	_host.actor_data.direction = _target_direction


func _check_if_conflict(_event_actors) -> bool:
	for _event_actor in _event_actors:
		for _actor in _all_actors:
			if _event_actors.has(_actor) and (not _actor == _event_actor):
				if _event_actor.actor_data.map_index.target == _actor.actor_data.map_index.target:
					return false
			elif not _event_actors.has(_actor):
				if _event_actor.actor_data.map_index.target == _actor.actor_data.map_index.current:
					return false
	return true