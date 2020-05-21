extends Node


var _all_actors := []
var _all_actors_requests := []


func _init() -> void:
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	_all_actors.clear()


func add_actor(_actor):
	var _current_index = _actor.actor_data.map_index.current
	_all_actors.append([_actor, _current_index])
	add_child(_actor)


# all actors must send some sort of signal, despite what state they are in. they must send there current index as there target
func _on_movement_request(_actor, target_index):
	_all_actors_requests.append([_actor, target_index])


func _physics_process(delta: float) -> void:
	if _all_actors_requests.size() < _all_actors.size():
		return
	if _check_for_conflicts():
		return


func _check_for_conflicts():
	var _requests_approved : bool
	for _requesting_actor in _all_actors_requests.size():
		for _actor in _all_actors.size():
			if not _all_actors_requests[_requesting_actor][1] == _all_actors[_actor][1]:
				continue
			if _all_actors[_actor][1] == _all_actors[_actor].actor_data.map_index.target:
				_requests_approved = false
				return _requests_approved
	_requests_approved = true
	return _requests_approved