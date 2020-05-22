extends Tween

var _animation_time:= 1 # based on 24 fps
var _animation_direction : String
onready var _parent_node = get_parent()

func _animate_actor(_start_position, _end_position) -> void:
	self.interpolate_property(_parent_node, "position",
			_start_position, _end_position, _animation_time,
			Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	self.start()

func _find_animation_direction():
	var _parent_current_index = _parent_node.get_current_index()
	var _parent_next_index = _parent_node.get_requested_index()
	
	if not _parent_current_index.x == _parent_next_index.x:
		if _parent_current_index.x < _parent_next_index.x:
			_animation_direction = "roll_right"
		else:
			_animation_direction = "roll_left"
	
	elif not _parent_current_index.y == _parent_next_index.y:
		if _parent_current_index.y < _parent_next_index.y:
			_animation_direction = "roll_down"
		else:
			_animation_direction = "roll_up"