extends Node2D
class_name Cube, "res://assets/tile_set/0000.png"

var _tween : Object

var _world_position : Vector2 setget set_world_position
var _current_index : Vector2 setget set_current_index, get_current_index
var _requested_index : Vector2 setget , get_requested_index
var _index_history := []

var _undo_requested := false

func _ready() -> void:
	# warning-ignore:return_value_discarded
	GLB_events_bus.connect("actor_index_update_granted", self, "_on_actor_index_update_granted")

func get_current_index():
	return _current_index

func get_requested_index():
	return _requested_index

func set_current_index(_new_index) -> void:
	_requested_index = _new_index
	GLB_events_bus.emit_signal("actor_index_update_requested", self, _current_index, _requested_index)

func _on_actor_index_update_granted(_actor, _position) -> void:
	if not _actor == self:
		return
	print("Moving.")
	_tween._animate_actor(_world_position, _position)
	yield(_tween, "tween_completed") # important
	if _undo_requested:
		_index_history.pop_front()
		_undo_requested = false
	else:
		_index_history.push_front(_requested_index)
	_current_index = _requested_index
	set_world_position(_position)

# Called from two places, the animation finsihed node, and the levels invalid move node.
func clear_groups():
	if self.is_in_group("moving"):
		self.remove_from_group("moving")

func set_world_position(_position):
	self.set_position(_position)
	_world_position = _position

# Called from move command
func add_to_current_index(_additional_index) -> void:
	var _index = _current_index
	set_current_index(_index + _additional_index)

# Called from undo command
func undo_last_move():
	if _index_history.size() <= 1:
		print("Cannot undo move. ", self)
		return
	print("Undoing move")
	_undo_requested = true
	set_current_index(_index_history[1])