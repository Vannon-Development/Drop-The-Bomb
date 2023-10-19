extends Node2D

signal set_bounds
signal door_exposed(pos: Vector2)

@export var box_object: PackedScene
@export var floor_object: PackedScene
@export var wall_object: PackedScene
@export var size: Vector2i
@export var box_fill: float

const _cell_size = 128

var _floor_list: Array
var _root: Node2D
var _box_list: Array[Node2D]

func box_count():
	return _box_list.size()

func _ready():
	_root = Node2D.new()
	_root.name = "Tiles"
	add_child(_root)
	
	var full_x = size.x * 2 + 1
	var full_y = size.y * 2 + 1
	
	for x in full_x:
		for y in full_y:
			if x == 0 || x == full_x - 1: _add_tile(wall_object, x, y)
			elif y == 0 || y == full_y - 1: _add_tile(wall_object, x, y)
			elif x % 2 == 0 && y % 2 == 0: _add_tile(wall_object, x, y)
			else: _add_tile(floor_object, x, y)
	_fill_boxes()
	
	set_bounds.emit(Rect2(Vector2.ZERO, Vector2((size.x * 2 + 1) * 128, (size.y * 2 + 1) * 128)))
	
func _fill_boxes():
	var fill = int(box_fill * _floor_list.size())
	for index in fill:
		var rand_index = randi_range(0, _floor_list.size() - 1)
		var pos = _floor_list[rand_index]
		_floor_list.remove_at(rand_index)
		_add_box(pos, index == 0)

func _add_box(pos: Vector2, has_door: bool):
	var box = box_object.instantiate()
	box.position = pos
	box.has_door = has_door
	box.box_destroyed.connect(_destroy_box)
	_box_list.append(box)
	if has_door:
		box.door_exposed.connect(_on_door_exposed)
	_root.add_child(box)
	
func _destroy_box(box: Node2D):
	var index = _box_list.find(box)
	_box_list.remove_at(index)

func _on_door_exposed(pos: Vector2):
	door_exposed.emit(pos)

func _add_tile(obj: PackedScene, x: int, y: int):
	var tile = obj.instantiate()
	tile.position = Vector2(x * 128 + 64, y * 128 + 64)
	if(obj == floor_object && (x > 2 || y > 2)): _floor_list.append(tile.position)
	_root.add_child(tile)
	
func open_spaces():
	return _floor_list

func has_box(loc: Vector2) -> bool:
	for box in _box_list:
		if (box.position - loc).is_zero_approx(): return true
	return false
