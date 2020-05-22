extends Node

var _all_actors := []

onready var _map_loader = get_node("../../TileMapLoader")
var _map_to_world_func
# Store a function reference.
# onready var _map_to_world_function = funcref(_map_func, "_convert_map_to_world")

func _init() -> void:
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	_all_actors.clear()

func _ready() -> void:
	GLB_events_bus.connect("map_to_world_function", self, "_on_map_to_world_function")

func _on_map_to_world_function(_map_func):
	_map_to_world_func = _map_func

func add_actor(_actor) -> void:
	var _starting_index = _actor.actor_data.map_index.starting
	_all_actors.append(_actor) # can add crrent state as well, may reomve duplciate code belwo , _current_index])
	_actor._world_position_function = _map_to_world_func
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
		_all_actors[_actor]._process_movement(_direction)


func _check_movement_command(_direction_vector) -> bool:
	var _idle_actors := []
	
	for _actor in _all_actors.size():
		if _all_actors[_actor].get_current_state_name() == "Idle":
			_idle_actors.append(_all_actors[_actor])
	
	for _idle_actor in _idle_actors.size():
		var _new_target_index = _idle_actors[_idle_actor].actor_data.map_index.current + _direction_vector
		
		if not _map_loader.is_index_valid(_new_target_index):
			return false
		
		_idle_actors[_idle_actor].actor_data.map_index.target = _new_target_index
		
		for _actor in _all_actors.size():
			if _idle_actors.has(_all_actors[_actor]):
				continue
			
			if _new_target_index == _all_actors[_actor].actor_data.map_index.current:
				return false
	return true


func _input(_event: InputEvent) -> void:
	
	if _event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if _event.is_action_pressed("ui_undo"):
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
		
		if not _map_loader.is_index_valid(_new_target_index):
			return false
		
		_locked_actors[_locked_actor].actor_data.map_index.target = _new_target_index
		
		for _actor in _all_actors.size():
			if _new_target_index == _all_actors[_actor].actor_data.map_index.current:
				return false
	return true