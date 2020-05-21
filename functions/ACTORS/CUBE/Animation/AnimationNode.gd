extends AnimationPlayer

signal animation_finished(_host, _animation_name)

onready var _respawn_halo = preload("res://assets/states/respawn/Respawn Halo.png")

onready var _actor := self.get_owner()
onready var _tween := $Tween

func _ready() -> void:
	_actor.connect("state_changed", self, "_on_state_changed")

func _on_state_changed(_new_state_name) -> void:
	play_animation(_new_state_name)

func play_animation(_new_state_name) -> void:
	# match function
	pass

func _all_nodes_finished():
	var _animation_name
	emit_signal("animation_finished", _animation_name)

func respawn_animation():
	for _halo in range(3):
		var _halo = _respawn_halo.instance()
		add_child(_halo)
	
	pass