extends Node

onready var map_loader = get_node("TileMapLoader")
onready var starting_map = preload("res://functions/LEVELS/Tile_Maps/Tile_Map_0.tscn")

func _ready() -> void:
	map_loader.load_map(starting_map)