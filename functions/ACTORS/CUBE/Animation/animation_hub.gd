extends AnimationPlayer

signal _AnimationHub_finished(animation_name)

# var _animation_time:= 0.2 # based on 24 fps

onready var _tween_node := $Tween
onready var _animation_node := $AnimationPlayer
onready var _animated_sprite := get_node("../TextureNode/AnimatedTexture")

func _ready() -> void:
	# _animated_sprite.set_speed_scale(1 / _animation_time)
	pass