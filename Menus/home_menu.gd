class_name MenuHome extends MenuBase

signal on_start();
signal on_settings();
signal on_credits();
signal on_upgrade();

@onready var icons: Array[Control] = [$"Start/Icon", $"Upgrade/Icon", $"Options/Icon", $"Credits/Icon"]
@onready var triggers: Array[Signal] = [on_start, on_upgrade, on_settings, on_credits]

func next() -> int:
	if selected == 3: return 0
	else: return selected + 1

func prev() -> int:
	if selected == 0: return 3
	else: return selected - 1

func trigger():
	triggers[selected].emit()

func update_visual():
	for index in icons.size():
		icons[index].modulate = Color.WHITE if selected == index else Color.TRANSPARENT
