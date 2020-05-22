extends State

var _host_current_index : Vector2
var _host_target_index : Vector2
var _host_current_world_position : Vector2
var _host_target_world_target : Vector2
var _direction : String

# Initialize the state. E.g. change the animation
func enter(_host):
	_host_current_index = _host.actor_data.map_index.current
	_host_target_index = _host.actor_data.map_index.target
	_host_current_world_position = _host.actor_data.world_position
	_host_target_world_target = _host.get_world_position(_host.actor_data.map_index.target)
	_direction = _get_direction(_host)
	
	_host._animation_player.play(_direction)
	_host._tween.interpolate_property(_host, "position",
			_host_current_world_position, _host_target_world_target, 1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	_host._tween.start()
	
	_host.actor_data.world_position = _host_target_world_target
	_host.actor_data.map_index.current = _host_target_index


func _on_animation_finished(_animation_name):
	if _animation_name == _direction:
		if Input.is_action_pressed(_direction):
			Input.action_press(_direction)
			Input.action_release(_direction)
			print("Auto pressing again")
		else:
			emit_signal("finished", "idle")


func _get_direction(_host):
	if not _host_current_index.x == _host_target_index.x:
		if _host_current_index.x < _host_target_index.x:
			return "ui_right"
		else:
			return "ui_left"
	
	elif not _host_current_index.y == _host_target_index.y:
		if _host_current_index.y < _host_target_index.y:
			return "ui_down"
		else:
			return "ui_up"