extends AnimationPlayer


var _animation_direction : String

onready var _respawn_halo = preload("res://assets/states/respawn/Respawn Halo.png")
onready var _actor := self.get_owner()
onready var _tween := $Tween


func start_animation(animation_name):
	play(animation_name)

func _find_animation_direction():
	var _parent_current_index = _actor.get_current_index()
	var _parent_next_index = _actor.get_requested_index()
	
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
	_tween.interpolate_property(_actor, "position",
			_start_position, _end_position, _animation_time,
			Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	_tween.start()
	_animated_sprite.play(_animation_direction)

func _on_AnimatedTexture_animation_finished() -> void:
	if _animated_sprite.animation != "idle" and _animated_sprite._is_playing():
        _animated_sprite.play("idle")
	_actor.clear_groups()
		# clear moving groups here
		# has something to do with multiple keys being pressed