extends Tween

var _animation_time:= 0.2 # based on 24 fps
var _animation_direction : String
onready var _parent_node = get_parent()
onready var _anitmation_node = _parent_node.get_node("TextureGridAlign/NodeCentre/AnimatedTexture")

func _ready() -> void:
	_anitmation_node.set_speed_scale(1 / _animation_time)
	
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

func _animate_actor(_start_position, _end_position) -> void:
	_find_animation_direction()
	self.interpolate_property(_parent_node, "position",
			_start_position, _end_position, _animation_time,
			Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	self.start()
	_anitmation_node.play(_animation_direction)

func _on_AnimatedTexture_animation_finished() -> void:
	if _anitmation_node.animation != "idle" and _anitmation_node._is_playing():
        _anitmation_node.play("idle")
	_parent_node.clear_groups()
		# clear moving groups here
		# has something to do with multiple keys being pressed