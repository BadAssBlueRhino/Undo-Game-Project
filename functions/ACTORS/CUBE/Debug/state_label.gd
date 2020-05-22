extends Label

onready var _scene_parent = self.get_owner()

func _ready() -> void:
	_scene_parent.connect("state_changed", self, "_on_state_changed")

func _on_state_changed(_new_state_name):
	self.set_text(_new_state_name)