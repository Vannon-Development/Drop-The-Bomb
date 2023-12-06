class_name MenuBase extends Node2D

var selected: int

func _process(_delta):
	update_visual()

func _input(event: InputEvent):
	if event.is_action_pressed("Up"):
		selected = prev()
	elif event.is_action_pressed("Down"):
		selected = next()
	elif is_two_column() and event.is_action_pressed("Left"):
		selected = prev_col()
	elif is_two_column() and event.is_action_pressed("Right"):
		selected = next_col()
	elif event.is_action_pressed("Game Start"):
		trigger()

func update_visual():
	pass

func is_two_column() -> bool:
	return false;

func next() -> int:
	return selected

func prev() -> int:
	return selected

func next_col() -> int:
	return selected

func prev_col() -> int:
	return selected

func trigger():
	pass
