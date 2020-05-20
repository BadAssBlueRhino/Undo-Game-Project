extends Node

onready var _actor := self.get_owner()
onready var _tween := $Tween
onready var _player := $AnimationPlayer

func _ready() -> void:
	_actor.connect("state_changed", self, "_on_state_changed")

func _on_state_changed(_new_state_name) -> void:
	_play_animation(_new_state_name)

func _play_animation(_new_state_name) -> void:
	# match function
	pass