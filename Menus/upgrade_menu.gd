class_name MenuUpgrade extends MenuBase

enum Items { bomb_count, bomb_size, walk_speed, remote, walk_wall, walk_bomb, back }

func is_two_column():
	return true

func next() -> int:
	if selected == Items.back:
		return Items.bomb_count
	else: return selected + 1

func prev() -> int:
	if selected == Items.bomb_count: return Items.back
	else: return selected + 1

func next_col() -> int:
	if selected == Items.back: return selected
	elif selected <= Items.walk_speed: return selected + 3
	else: return selected - 3

func prev_col() -> int:
	if selected == Items.back: return selected
	elif selected <= Items.walk_speed: return selected + 3
	else: return selected - 3

func update_visual():
