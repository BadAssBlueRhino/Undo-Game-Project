extends Node

var _all_actors := []

onready var _map_loader = "../../TileMapLoader"

func _init() -> void:
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	_all_actors.clear()


func add_actor(_actor) -> void:
	var _current_index = _actor.actor_data.map_index.current
	_all_actors.append([_actor, _current_index])
	add_child(_actor)


func _physics_process(delta: float) -> void:
	var _input := Input
	var _direction := Vector2()
	if _input.is_action_pressed("ui_up"):
		_direction = Vector2(0, -1)
	elif _input.is_action_pressed("ui_right"):
		_direction = Vector2(1, 0)
	elif _input.is_action_pressed("ui_down"):
		_direction = Vector2(0, 1)
	elif _input.is_action_pressed("ui_left"):
		_direction = Vector2(-1, 0)
	
	if _direction == Vector2() or not _check_movement_command(_direction):
		return
	
	for _actor in _all_actors.size():
		_all_actors[_actor]._process_movement()


func _check_movement_command(_direction_vector) -> bool:
	var _idle_actors := []
	
	for _actor in _all_actors.size():
		if _all_actors[_actor].get_current_state_name() == "Idle":
			_idle_actors.append(_all_actors[_actor])
	
	for _idle_actor in _idle_actors.size():
		var _new_target_index = _idle_actors[_idle_actor].actor_data.map_index.current + _direction_vector
		
		if not _map_loader.is_index_valid():
			print("Can not move, the target space is invalid.")
			return false
		
		_idle_actors[_idle_actor].actor_data.map_index.target = _new_target_index
		
		for _actor in _all_actors.size():
			if _idle_actors.has(_all_actors[_actor]):
				continue
			
			if _new_target_index == _all_actors[_actor].actor_data.map_index.current:
				print("Can not move, the target space is occupied.")
				return false
		
	print("Can move. All actors approve.")
	return true


func _input(_event: InputEvent) -> void:
	if _event.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if _event.is_action_just_pressed("ui_undo"):
		if not _check_undo_command():
			return
		for _actor in _all_actors.size():
			_all_actors[_actor]._process_duplication()


func _check_undo_command() -> bool:
	var _locked_actors := []
	
	for _actor in _all_actors.size():
		if _all_actors[_actor].get_current_state_name() == "Lock":
			_locked_actors.append(_all_actors[_actor])
	
	for _locked_actor in _locked_actors.size():
		var _new_target_index = _locked_actors[_locked_actor].actor_data.map_index.history[0]
		
		if not _map_loader.is_index_valid():
			print("Can not move, the target space is invalid.")
			return false
		
		_locked_actors[_locked_actor].actor_data.map_index.target = _new_target_index
		
		for _actor in _all_actors.size():
			if _new_target_index == _all_actors[_actor].actor_data.map_index.current:
				print("Can not move, the target space is occupied.")
				return false
	
	print("Can undo. All actors approve.")
	return true