extends Node

enum Selection { Bomb, Size, Speed, Remote, Wall, Bomb_Walk }

@export var crystal_count: Label

@export_group("Bomb Count Section")
@export var bomb_label: Label
@export var bomb_price: Label
@export var bomb_crystal: Sprite2D
@export var bomb_icon_lit: Sprite2D
@export var bomb_icon_gray: Sprite2D

@export_group("Bomb Size Section")
@export var size_label: Label
@export var size_price: Label
@export var size_crystal: Sprite2D
@export var size_icon_lit: Sprite2D
@export var size_icon_gray: Sprite2D

@export_group("Walk Speed Section")
@export var speed_label: Label
@export var speed_price: Label
@export var speed_crystal: Sprite2D
@export var speed_icon_lit: Sprite2D
@export var speed_icon_gray: Sprite2D

@export_group("Remote Section")
@export var remote_price: Label
@export var remote_crystal: Sprite2D
@export var remote_all_icon_lit: Sprite2D
@export var remote_all_icon_gray: Sprite2D
@export var remote_single_icon_lit: Sprite2D
@export var remote_single_icon_gray: Sprite2D

@export_group("Wall Walk Section")
@export var wall_walk_price: Label
@export var wall_walk_crystal: Sprite2D
@export var wall_walk_icon_lit: Sprite2D
@export var wall_walk_icon_gray: Sprite2D

@export_group("Bomb Walk Section")
@export var bomb_walk_price: Label
@export var bomb_walk_crystal: Sprite2D
@export var bomb_walk_icon_lit: Sprite2D
@export var bomb_walk_icon_gray: Sprite2D

var _selection: Selection

func _ready():
	_selection = Selection.Bomb
	_update_prices()
	_update_icons()

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		_return_home()
	if Input.is_action_just_pressed("Up"):
		_selection = max(0, _selection - 1)
		_update_icons()
	if Input.is_action_just_pressed("Down"):
		_selection = min(Selection.size() - 1, _selection + 1)
		_update_icons()
	if Input.is_action_just_pressed("Left") && _selection >= 4:
		_selection = max(0, _selection - 4)
		_update_icons()
	if Input.is_action_just_pressed("Right") && _selection < 4:
		_selection = min(Selection.size() - 1, _selection + 4)
		_update_icons()
	if Input.is_action_just_pressed("Game Start"):
		var price = _find_price(_selection)
		if price > Data.crystals: _not_enough()
		elif price != 0: _buy_item(_selection)

func _return_home():
	var menu = load("res://Objects/start_screen.tscn")
	var obj = menu.instantiate()
	get_parent().add_child(obj)
	queue_free()

func _update_prices():
	bomb_label.text = str(Data.bomb_count)
	size_label.text = str(Data.bomb_size)
	speed_label.text = str(Data.walk_speed)

	if Data.bomb_count < 10:
		bomb_price.text = "x " + str(_find_price(Selection.Bomb))
	else:
		bomb_price.text = "MAX"
		bomb_crystal.visible = false

	if Data.bomb_size < 10:
		size_price.text = "x " + str(_find_price(Selection.Size))
	else:
		size_price.text = "MAX"
		size_crystal.visible = false

	if Data.walk_speed < 9:
		speed_price.text = "x " + str(_find_price(Selection.Speed))
	else:
		speed_price.text = "MAX"
		speed_crystal.visible = false

	if Data.remote_type < 2:
		remote_price.text = "x " + str(_find_price(Selection.Remote))
	else:
		remote_price.text = "MAX"
		remote_crystal.visible = false

	if !Data.wall_walk:
		wall_walk_price.text = "x " + str(_find_price(Selection.Wall))
	else:
		wall_walk_price.text = "MAX"
		wall_walk_crystal.visible = false

	if !Data.bomb_walk:
		bomb_walk_price.text = "x " + str(_find_price(Selection.Bomb_Walk))
	else:
		bomb_walk_price.text = "MAX"
		bomb_walk_crystal.visible = false

	crystal_count.text = "x " + str(Data.crystals)

func _update_icons():
	bomb_icon_lit.visible = _selection == Selection.Bomb
	bomb_icon_gray.visible = _selection != Selection.Bomb
	size_icon_lit.visible = _selection == Selection.Size
	size_icon_gray.visible = _selection != Selection.Size
	speed_icon_lit.visible = _selection == Selection.Speed
	speed_icon_gray.visible = _selection != Selection.Speed
	remote_all_icon_gray.visible = _selection != Selection.Remote && Data.remote_type == 0
	remote_all_icon_lit.visible = _selection == Selection.Remote && Data.remote_type == 0
	remote_single_icon_gray.visible = _selection != Selection.Remote && Data.remote_type != 0
	remote_single_icon_lit.visible = _selection == Selection.Remote && Data.remote_type != 0
	wall_walk_icon_gray.visible = _selection != Selection.Wall
	wall_walk_icon_lit.visible = _selection == Selection.Wall
	bomb_walk_icon_lit.visible = _selection == Selection.Bomb_Walk
	bomb_walk_icon_gray.visible = _selection != Selection.Bomb_Walk
	pass

func _find_price(item: Selection):
	if item == Selection.Bomb && Data.bomb_count < 10:
		return prices["Bomb"][Data.bomb_count - 1]
	if item == Selection.Size && Data.bomb_size < 10:
		return prices["Size"][Data.bomb_size - 1]
	if item == Selection.Speed && Data.walk_speed < 9:
		return prices["Speed"][Data.walk_speed - 1]
	if item == Selection.Remote && Data.remote_type < 2:
		return prices["Remote"][Data.remote_type]
	if item == Selection.Wall && !Data.wall_walk:
		return prices["Wall"][0]
	if item == Selection.Bomb_Walk && !Data.bomb_walk:
		return prices["Bomb Walk"][0]
	return 0

func _not_enough():
	pass

func _buy_item(sel: Selection):
	var price = _find_price(sel)
	if price == 0: return

	Data.crystals -= price
	if sel == Selection.Bomb: Data.bomb_count += 1
	elif sel == Selection.Size: Data.bomb_size += 1
	elif sel == Selection.Speed: Data.walk_speed += 1
	elif sel == Selection.Remote: Data.remote_type += 1
	elif sel == Selection.Wall: Data.wall_walk = true
	elif sel == Selection.Bomb_Walk: Data.bomb_walk = true

	Data.save_data()
	_update_prices()
	_update_icons()

var prices = {
	"Bomb": [10, 20, 40, 80, 200, 400, 1000, 1500, 2000],
	"Size": [5, 30, 60, 100, 300, 800, 1200, 2000, 4000],
	"Speed": [25, 50, 100, 200, 400, 800, 1500, 2500],
	"Remote": [250, 1500],
	"Wall": [1800],
	"Bomb Walk": [1600]
	}

