extends Label

func _process(_delta: float) -> void:
	if is_in_group("locked"):
		self.visible