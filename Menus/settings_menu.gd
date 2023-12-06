class_name MenuSettings extends MenuBase

signal on_back()

enum Items { music, erase, back }

@onready var _icons: Array[Control] = [$"Music/Icon", $"Erase/Icon", $"Back/Icon"]
@onready var _music_status: Label = $"Music/Status"
@onready var _triggers: Array[Callable] = [_on_music, _on_erase, _on_back]

func next() -> int:
	if selected == Items.back: return Items.music
	else: return selected + 1

func prev() -> int:
	if selected == Items.music: return Items.back
	else: return selected - 1

func trigger():
	_triggers[selected].call()

func update_visual():
	for index in _icons.size():
		_icons[index].modulate = Color.WHITE if selected == index else Color.TRANSPARENT
	_music_status.text = "Off" if Data.music_mute else "On"

func _on_erase():
	Data.full_clear()

func _on_music():
	Data.music_mute = not Data.music_mute
	Data.save_data()

func _on_back():
	on_back.emit()
