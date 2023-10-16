class_name menu_select
extends Node2D

var selection_cursors: Array[Node2D]
var actions: Array[Callable]

var _selected: int

func _ready():
	_selected = 0
	_update_visual()

func _process(_delta):
	if Input.is_action_just_pressed("Up"):
		_selected = max(0, _selected - 1)
		_update_visual()
	if Input.is_action_just_pressed("Down"):
		_selected = min(selection_cursors.size() - 1, _selected + 1)
		_update_visual()
	if Input.is_action_just_pressed("Game Start"):
		actions[_selected].call()

func _update_visual():
	for item in selection_cursors.size():
		selection_cursors[item].visible = _selected == item
