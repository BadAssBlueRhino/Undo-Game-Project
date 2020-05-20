extends Node

func execute(_actor, _direction) -> void:
	var _new_index = _match_direction_key(_direction)
	_actor.add_to_current_index(_new_index)

func _match_direction_key(_direction) -> Vector2:
	match _direction:
		"up":
			print("Up")
			return Vector2(0, -1)
		"right":
			print("Right")
			return Vector2(1, 0)
		"down":
			print("Down")
			return Vector2(0, 1)
		"left":
			print("Left")
			return Vector2(-1, 0)