extends Node

onready var actor_scene_path = preload("res://functions/ACTORS/CUBE/Cube.tscn")
var _actors : Array setget , get_actors

func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("actor_generated", self, "_on_actor_generated")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("level_restarted", self, "_on_level_restarted")

func are_any_actors_in_group(_name):
	for _actor in _actors.size():
		if _actors[_actor].is_in_group(_name):
			return true
	return false

func actors_in_group(_name):
	var _actors_in_group := []
	for _actor in _actors.size():
		if _actors[_actor].is_in_group(_name):
			_actors_in_group.append(_actors[_actor])
		else:
			continue
	return _actors_in_group

func actors_not_in_group(_name):
	var _actors_not_in_group := []
	for _actor in _actors.size():
		if _actors[_actor].is_in_group(_name):
			continue
		else:
			_actors_not_in_group.append(_actors[_actor])
	return _actors_not_in_group

func add_all_actors_to_group(_name):
	for _actor in _actors.size():
		_actors[_actor].add_to_group(_name)

func remove_all_actors_from_groups(_name_array):
	for _group_name in _name_array.size():
		for _actor in _actors.size():
			_actors[_actor].remove_from_group(_name_array[_group_name])

# Animation is a beam of light from above
func _on_actor_generated(_index):
	print("Actor generating...")
	var _new_actor = actor_scene_path.instance()
	_actors.append(_new_actor)
	self.add_child(_new_actor)
	_new_actor.set_current_index(_index)

# Animation is a cell splitting
func _on_actor_duplicated(_actor):
	print("Actor duplicating...")
	# var _duplicate_index = _actor.get_current_index()
	var _duplicate_actor = _actor.dupliacte()
	# _duplicate_actor.set_current_index(_duplicate_index)
	_actors.append(_duplicate_actor)
	self.add_child(_duplicate_actor)
	pass

func _on_level_restarted(_starting_index):
	if not get_child_count() == 0:
		for _child in get_children():
			_child.queue_free()
	_actors.clear()
	_on_actor_generated(_starting_index)

func get_actors():
	return _actors