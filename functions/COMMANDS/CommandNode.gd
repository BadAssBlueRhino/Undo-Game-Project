extends Node

onready var factory = get_node("/root/Main/CubeFactory")
onready var move_command := $MoveCommand
onready var undo_command := $UndoCommand

func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("direction_key_pressed", self, "_on_direction_key_pressed")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("trigger_locked_group", self, "_on_trigger_locked_group")
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("undo_action_signaled", self, "_on_undo_action_signaled")

func _any_actors_moving():
	if factory.are_any_actors_in_group("moving"):
		return true
	return false

func _on_direction_key_pressed(_direction):
	if _any_actors_moving():
		return
	var _actors = factory.actors_not_in_group("locked")
	for _actor in _actors.size():
		_actors[_actor].add_to_group("moving")
		move_command.execute(_actors[_actor], _direction)

func _on_trigger_locked_group(_is_triggered):
	if _any_actors_moving():
		return
	if _is_triggered:
		factory.add_all_actors_to_group("locked")
	elif not _is_triggered:
		factory.remove_all_actors_from_groups(["locked", "cooling_down"])

func _on_undo_action_signaled():
	if _any_actors_moving():
		return
	var _actors = factory.actors_not_in_group("cooling_down")
	for _actor in _actors.size():
		undo_command.execute(_actors[_actor])
	var _locked_actors = factory.actors_in_group("locked")
	for _actor in _locked_actors.size():
		_locked_actors[_actor].add_to_group("cooling_down")