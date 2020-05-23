extends AnimationPlayer


#onready var _host = self.get_owner()


# figures how to set the time for everything (Animations)
# figure out how to remove micro freezes from moving to moving state, without idle inbetween


#func _ready() -> void:
#	var speed_scale = 1 / _host._animation_speed
#	playback_speed = speed_scale
#	_host._animated_sprite.speed_scale = speed_scale