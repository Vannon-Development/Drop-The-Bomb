extends Node

enum Selection { Bomb, Size, Speed }

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
	if Input.is_action_just_pressed("Game Start"):
		var price = _find_price(_selection)
		if price >= Data.crystals: _not_enough()
		else: _buy_item(_selection)

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
	
	crystal_count.text = "x " + str(Data.crystals)

func _update_icons():
	bomb_icon_lit.visible = _selection == Selection.Bomb
	bomb_icon_gray.visible = _selection != Selection.Bomb
	size_icon_lit.visible = _selection == Selection.Size
	size_icon_gray.visible = _selection != Selection.Size
	speed_icon_lit.visible = _selection == Selection.Speed
	speed_icon_gray.visible = _selection != Selection.Speed
	pass
	
func _find_price(item: Selection):
	if item == Selection.Bomb:
		return prices["Bomb"][Data.bomb_count - 1]
	if item == Selection.Size:
		return prices["Size"][Data.bomb_size - 1]
	if item == Selection.Speed:
		return prices["Speed"][Data.walk_speed - 1]
	return 0

func _not_enough():
	pass

func _buy_item(sel: Selection):
	if sel == Selection.Bomb:
		Data.crystals -= _find_price(Selection.Bomb)
		Data.bomb_count += 1
	elif sel == Selection.Size:
		Data.crystals -= _find_price(Selection.Size)
		Data.bomb_size += 1
	elif sel == Selection.Speed:
		Data.crystals -= _find_price(Selection.Speed)
		Data.walk_speed += 1
	Data.save_data()
	_update_prices()

var prices = { 
	"Bomb": [10, 20, 40, 80, 200, 400, 1000, 1500, 2000],
	"Size": [5, 30, 60, 100, 300, 800, 1200, 2000, 4000],
	"Speed": [25, 50, 100, 200, 400, 800, 1500, 2500]
	}

