extends Node


onready var actor_scene_path = preload("res://functions/ACTORS/CUBE/Cube.tscn")
onready var _holding_pen = $ActorHoldingPen


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("level_restarted", self, "_on_level_restarted")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("duplicate_actor", self, "_on_duplicate_actor")


func _on_level_restarted(_starting_index):
	_holding_pen._init()
	_actor_respawned(_starting_index)


# Animation is a beam of light from above
func _actor_respawned(_index):
	print("Actor respawning...")
	var _new_actor = actor_scene_path.instance()
	_new_actor.initalize_state(_index)
	_holding_pen.add_actor(_new_actor)


# Animation is a cell splitting/ Cell opening up like a robot factory and a small guy rolls out.
func _on_duplicate_actor(_actor, _target_index):
	print("Actor duplicating...")
	var _duplicate_actor = _actor.duplicate()
	copy_important_data(_actor, _duplicate_actor)
	_duplicate_actor.initalize_state( _actor.actor_data.map_index.current, _target_index)
	_holding_pen.add_actor(_duplicate_actor)


func copy_important_data(_actor, _duplicate_actor):
	_duplicate_actor.actor_data = _actor.actor_data.duplicate(true)
	_duplicate_actor.state = _actor.state.duplicate(true)