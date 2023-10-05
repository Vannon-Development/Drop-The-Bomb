extends Node2D

@export var level: int
@export var level_map: Node2D
@export var player: Node2D
@export var camera: Camera2D
@export var bomb_object: PackedScene
@export var explosion_object: PackedScene
@export var door_object: PackedScene
@export var crystal_object: PackedScene
@export var level_display: PackedScene

var _bomb_list: Array
var _enemy_list: Array
var _enemy_objects: Array

var _bomb_count: int
var _bomb_size: int
var _box_count: int
var _start_time: int

func _ready():
	_enemy_objects = [{ "object": preload("res://Objects/bat.tscn"), "strength": 1 }]
	_bomb_count = Data.bomb_count
	_bomb_size = Data.bomb_size
	_add_enemies()
	_box_count = level_map.box_count()
	_start_time = Time.get_ticks_msec()
	
	var lvl_disp = level_display.instantiate()
	lvl_disp.set_level(level)
	add_child(lvl_disp)

func _on_drop_bomb():
	if _bomb_list.size() >= _bomb_count: return
	var pos = _pos_to_grid(player.position)
	for item in _bomb_list:
		if item.position.x == pos.x && item.position.y == pos.y: return
	var bomb = bomb_object.instantiate()
	bomb.position = pos
	bomb.explode.connect(_on_explode)
	_bomb_list.append(bomb)
	add_child(bomb)

func _on_explode(bomb: Node2D):
	var ex = explosion_object.instantiate() as Node2D
	ex.position = bomb.position
	ex.size = _bomb_size
	add_child(ex)
	_bomb_list.remove_at(_bomb_list.find(bomb))
	bomb.queue_free()

func _add_enemies():
	var size = level
	while size > 0:
		var rand_item
		while true:
			rand_item = _enemy_objects[randi_range(0, _enemy_objects.size() - 1)]
			if rand_item["strength"] <= size: break
		size -= rand_item["strength"]
		var enemy = rand_item["object"].instantiate() as Node2D
		var spaces = level_map.open_spaces()
		enemy.position = spaces[randi_range(0, spaces.size() - 1)]
		enemy.drop_crystal.connect(_on_add_crystal)
		enemy.dead.connect(_on_enemy_dead)
		add_child(enemy)
		_enemy_list.append(enemy)
		
func _on_game_lost():
	var obj = load("res://Objects/start_screen.tscn").instantiate()
	get_parent().add_child(obj)
	queue_free()

func _on_level_door_exposed(pos: Vector2):
	var d = door_object.instantiate()
	d.position = pos
	d.door_entered.connect(_on_door_entered)
	add_child(d)
	
func _on_door_entered():
	if _enemy_list.size() == 0: _level_end_sequence()
	
func _on_enemy_dead(enemy: Node2D):
	var index = _enemy_list.find(enemy)
	_enemy_list.remove_at(index)

func _on_add_crystal(pos: Vector2, quantity: int):
	var obj = crystal_object.instantiate()
	obj.position = _pos_to_grid(pos)
	obj.quantity = quantity
	call_deferred("add_child", obj)
	
func _pos_to_grid(pos: Vector2):
	var x = int(pos.x / 128) * 128 + 64
	var y = int(pos.y / 128) * 128 + 64
	return Vector2(x, y)

var _level_end_started: bool = false

func _level_end_sequence():
	if _level_end_started: return
	_level_end_started = true
	var obj = load("res://Objects/level_end_screen.tscn").instantiate()
	obj.set_values(level, int((_box_count - level_map.box_count()) / float(_box_count) * 100), int((Time.get_ticks_msec() - _start_time) / 1000.0))
	obj.dismissed.connect(_next_level)
	obj.position = camera.get_screen_center_position() - camera.get_viewport_rect().size / 2
	add_child(obj)
	GameControl.pause()

func _next_level():
	var obj = load("res://Objects/game_level.tscn").instantiate()
	obj.level = level + 1
	get_parent().call_deferred("add_child", obj)
	GameControl.reset()
	queue_free()
