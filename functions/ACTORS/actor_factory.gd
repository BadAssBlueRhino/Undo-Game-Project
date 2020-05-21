extends Node


onready var actor_scene_path = preload("res://functions/ACTORS/CUBE/Cube.tscn")
onready var _holding_pen = $ActorHoldingPen


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("actor_generated", self, "_on_actor_generated")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("actor_duplicated", self, "_on_actor_duplicated")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("level_restarted", self, "_on_level_restarted")

# Animation is a beam of light from above
func _on_actor_respawned(_index):
	print("Actor respawning...")
	var _new_actor = actor_scene_path.instance()
	_new_actor._change_map_starting_index(_index)
	_new_actor._change_starting_state("respawn")
	_holding_pen._all_actors.append(_new_actor)
	_holding_pen.add_child(_new_actor)

# Animation is a cell splitting
func _on_actor_duplicated(_actor):
	print("Actor duplicating...")
	# var _duplicate_index = _actor.get_current_index()
	var _duplicate_actor = _actor.dupliacte()
	# _duplicate_actor.set_current_index(_duplicate_index)
	_actor._change_starting_state("duplicate")
	_holding_pen._all_actors.append(_duplicate_actor)
	_holding_pen.add_child(_duplicate_actor)


func _on_level_restarted(_starting_index):
	_holding_pen._init()
	_on_actor_respawned(_starting_index)