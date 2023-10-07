extends Node

signal on_pause
signal on_resume(delta: int)

var total_crystals: int

var _paused: bool = false
var _pause_time: int

func pause():
	_paused = true
	_pause_time = Time.get_ticks_msec()
	on_pause.emit()
	
func resume():
	_paused = false
	on_resume.emit(Time.get_ticks_msec() - _pause_time)

func reset():
	_paused = false

func is_paused():
	return _paused

func start_game():
	total_crystals = 0
	_paused = false
