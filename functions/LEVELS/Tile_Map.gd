extends TileMap

var grid : Array = get_used_cells()
var gen_cubes := 4
var _cell_centre_offset : Vector2
var y_vec = Vector2(0, -35) # Correct the cube trandorms, to the exact number

onready var cube_factory = find_node("CubeFactory")
onready var cube = preload("res://Scenes/Cube.tscn")

func _ready():
	# Emiti a signal to place a cue at the starting position
	
	_cell_centre_offset = _get_cell_centre()
	var positions = []
	
	print(grid)
	
	positions.append(grid[0])
	positions.append(grid[1])
	positions.append(grid[2])
	positions.append(grid[3])
	print(get_custom_transform())
	print(_cell_centre_offset)
	
	for pos in positions:
		var new_cube = cube.instance()
		new_cube.set_starting_postion(map_to_world(pos) + _cell_centre_offset + y_vec)
		# cube_factory.add_child(new_cube)

func is_cell_vacant():
	pass

func update_child_pos(child, new_pos, direction):
	pass

func _get_cell_centre() -> Vector2:
	var transform_array = get_custom_transform()
	var array_1 = transform_array[0]
	var array_2 = transform_array[1]
	return ( array_1 + array_2 ) / 2