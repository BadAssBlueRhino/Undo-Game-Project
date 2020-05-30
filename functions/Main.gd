extends Node

# Notes to do:
# Add a timeer. Remove the move counter, or keep both
# Add persistant score for your machine.


onready var map_loader = find_node("TileMapLoader")
onready var actor_holding_pen = find_node("ActorHoldingPen")


func _ready() -> void:
	map_loader.load_starting_map()


func _physics_process(_delta: float) -> void:
	if not actor_holding_pen.can_actors_receive_input():
		return
	_check_win_conditions()


func _check_win_conditions() -> void:
	var _win_conditions_met = 0
	var _current_actors = actor_holding_pen._all_actors
	var _all_win_tiles = map_loader.end_goal_indexs
	for _actor in _current_actors:
		if _actor.actor_data.map_index.current in _all_win_tiles:
			_win_conditions_met += 1
		if _win_conditions_met == _all_win_tiles.size():
			print("You win!")
			GLB_events_bus.emit_signal("level_won")
			return
		else:
			continue