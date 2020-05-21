extends "res://functions/COMMANDS/InputHandler.gd"
# change this to a standard node that will house all the actors.
# make sure to updated the factory so it sends and clears all the actors from here
# remane it to... ActorCommand
# We STILL may need an actor pen...

var _movement_started := false
var _movement_direction := Vector2()
var _undo_started := false
var _lock_started := false

func _init() -> void:
	_movement_started = false
	_movement_direction = Vector2()
	_undo_started = false
	_lock_started = false

func _process(_delta: float) -> void:
	if 

func _on_movement_started(_direction_vector):
	var _actor_state = "idle"
	if _actor.state.current == _actor_state:
		


func _on_lock_engaged():
	# send actors the locked state.
	# Individual actors will be in charge to determine if they can accept the lock state.
	pass


func _on_undo_started():
	pass