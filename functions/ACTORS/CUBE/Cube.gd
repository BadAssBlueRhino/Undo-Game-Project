extends Actor


var _world_position_function = null


func _ready() -> void:
	set_animation_speed()
	actor_data.world_position = get_world_position(actor_data.map_index.starting)
	if not actor_data.world_position == null:
		position = actor_data.world_position
	for state_node in $States.get_children():
		state_node.connect("finished", self, "_change_state")
	if state.starting == null:
		push_error("ERROR: Actor starting index not initalized.")
		return
	_change_state(state.starting)


func set_animation_speed():
	var speed_scale = 1 / _animation_speed
	_animation_player.playback_speed = speed_scale
	_animated_sprite.speed_scale = speed_scale


func get_world_position(_index):
	if _world_position_function == null:
		return null
	return _world_position_function.call_func(_index)


func _input(_event) -> void:
	if not _event.is_action("ui_lock") or state.current == null:
		return
	var _new_state_name = state.current.handle_input(self, _event)
	if _new_state_name:
		_change_state(_new_state_name)


func _process_movement(_direction_vector):
	print("updating target")
	# actor_data.map_index.target = actor_data.map_index.current + _direction_vector
	var _new_state_name = state.current.handle_key_event(self, "update_position")
	if _new_state_name:
		_change_state(_new_state_name)


func _process_duplication():
	var _new_state_name = state.current.handle_key_event(self, "duplicate")
	if _new_state_name:
		_change_state(_new_state_name)