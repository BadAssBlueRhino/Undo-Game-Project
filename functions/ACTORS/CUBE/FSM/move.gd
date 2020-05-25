extends State


var _host_current_index : Vector2
var _host_target_index : Vector2
var _host_current_world_position : Vector2
var _host_target_world_target : Vector2
var _host_direction : String
var _host_animation_speed : float


# Initialize the state. E.g. change the animation
func enter(_host):
	print("Moving: ", _host)
	_host.state.can_receive = false
	_get_inital_values(_host)
	_host._animation_player.play(_host_direction)
	_host._tween.interpolate_property(_host, "position",
			_host_current_world_position, _host_target_world_target, _host_animation_speed,
			Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	_host._tween.start()
	if _host.state.previous_stack[1].get_name() == "IdleDuplicate":
		_host.actor_data.map_index.history.pop_front()
	else:
		_host.actor_data.map_index.history.push_front(_host_current_index)
	_host.actor_data.world_position = _host_target_world_target
	_host.actor_data.map_index.current = _host_target_index


func exit(_host):
	_host.state.can_receive = true

func _get_inital_values(_host):
	_host_current_index = _host.actor_data.map_index.current
	_host_target_index = _host.actor_data.map_index.target
	_host_current_world_position = _host.actor_data.world_position
	_host_target_world_target = _host.get_world_position(_host.actor_data.map_index.target)
	_host_direction = _host.actor_data.direction
	_host_animation_speed = _host._animation_speed


func _on_animation_finished(_animation_name):
	if _animation_name == _host_direction:
		emit_signal("finished", "previous")