extends AnimationPlayer

signal animation_finished(_host, _animation_name)

onready var _respawn_halo = preload("res://assets/states/respawn/Respawn Halo.png")

onready var _actor := self.get_owner()
onready var _tween := $Tween

func start_animation(animation_name):
	play(animation_name)