class_name MenuUpgrade extends MenuBase

#TODO Still needs crystal count and FULL testing

signal on_back()

enum Items { bomb_count, bomb_size, walk_speed, remote, walk_wall, walk_bomb, back }

@onready var _lit_icon: Array[Control] = [
	$"Bomb Count/Icon Lit", $"Bomb Size/Icon Lit", $"Speed/Icon Lit",
	$"Remote/Icon Lit", $"Wall Walk/Icon Lit", $"Bomb Walk/Icon Lit",
	$"Back/Icon"
]

@onready var _unlit_icon: Array[Control] = [
	$"Bomb Count/Icon Unlit", $"Bomb Size/Icon Unlit", $"Speed/Icon Unlit",
	$"Remote/Icon Unlit", $"Wall Walk/Icon Unlit", $"Bomb Walk/Icon Unlit",
	$"Back/Icon"
]

@onready var _levels: Array[Label] = [
	$"Bomb Count/Level", $"Bomb Size/Level", $"Speed/Level"
]

@onready var _price_labels: Array[Label] = [
	$"Bomb Count/Cost", $"Bomb Size/Cost", $"Speed/Cost",
	$"Remote/Cost", $"Wall Walk/Cost", $"Bomb Walk/Cost"
]

@onready var _crystals: Array[Control] = [
	$"Bomb Count/Crystal Set", $"Bomb Size/Crystal Set", $"Speed/Crystal Set",
	$"Remote/Crystal Set", $"Wall Walk/Crystal Set", $"Bomb Walk/Crystal Set"
]

@onready var _crystal_counter: Label = $"Crystal Count/Text"

@onready var _prices: Array = [
	[10, 20, 40, 80, 200, 400, 1000, 1500, 2000],
	[5, 30, 60, 100, 300, 800, 1200, 2000, 4000],
	[25, 50, 100, 200, 400, 800, 1500, 2500],
	[250, 1500],
	[1800],
	[1600]

]

@onready var _remote_alt_lit: Control = $"Remote/Alt Icon Lit"
@onready var _remote_alt_unlit: Control = $"Remote/Alt Icon Unlit"

func is_two_column():
	return true

func next() -> int:
	if selected == Items.back:
		return Items.bomb_count
	else: return selected + 1

func prev() -> int:
	if selected == Items.bomb_count: return Items.back
	else: return selected - 1

func next_col() -> int:
	if selected == Items.back: return selected
	elif selected <= Items.walk_speed: return selected + 3
	else: return selected - 3

func prev_col() -> int:
	if selected == Items.back: return selected
	elif selected <= Items.walk_speed: return selected + 3
	else: return selected - 3

func update_visual():
	var level := _levels_from_data()
	for index in Items.size():
		_lit_icon[index].visible = index == selected
		_unlit_icon[index].visible = index != selected
		var sel_level: int = 0
		if index < 3: sel_level = level[index] - 1
		elif index < 6: sel_level = level[index]
		if index < 3: _levels[index].text = str(level[index])
		if index < 6:
			if sel_level < _prices[index].size():
				_price_labels[index].text = str(_prices[index][sel_level])
				_crystals[index].visible = true
			else:
				_price_labels[index].text = "MAX"
				_crystals[index].visible = false
		if index == Items.back:
			_lit_icon[index].visible = true
			_lit_icon[index].modulate = Color.WHITE if selected == index else Color.TRANSPARENT
		if index == Items.remote:
			_lit_icon[index].visible = level[index] == 0 and index == selected
			_unlit_icon[index].visible = level[index] == 0 and index != selected
			_remote_alt_lit.visible = level[index] > 0 and index == selected
			_remote_alt_unlit.visible = level[index] > 0 and index != selected
	_crystal_counter.text = str(Data.crystals)

func trigger():
	if selected == Items.back:
		on_back.emit()
		return

	var level := _levels_from_data()
	var sel_level = level[selected] if selected >= 3 else level[selected] - 1
	if sel_level >= _prices[selected].size(): return
	var price: int = _prices[selected][sel_level]
	if Data.crystals < price: return
	Data.crystals -= price
	if selected == Items.bomb_size: Data.bomb_size += 1
	elif selected == Items.bomb_count: Data.bomb_count += 1
	elif selected == Items.walk_speed: Data.walk_speed += 1
	elif selected == Items.remote: Data.remote_type += 1
	elif selected == Items.walk_wall: Data.wall_walk = true
	elif selected == Items.walk_bomb: Data.bomb_walk = true
	Data.save_data()

func _levels_from_data() -> Array[int]:
	return [
		Data.bomb_count, Data.bomb_size, Data.walk_speed,
		Data.remote_type, 1 if Data.wall_walk else 0, 1 if Data.bomb_walk else 0
	]
