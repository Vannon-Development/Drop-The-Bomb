extends AudioStreamPlayer

enum SoundMode {music, effect, both}

@export var mode: SoundMode

func _ready():
	playing = not Data.music_mute
	Data.music_mute_changed.connect(_on_music_mute)

func _on_music_mute(val: bool):
	if mode == SoundMode.music or mode == SoundMode.both:
		playing = not val

func _on_effect_mute(_val: bool):
	pass
