extends Node

var crystals: int
var bomb_size: int
var bomb_count: int
var walk_speed: int

func save_data():
	var save_game = FileAccess.open("user://data.save", FileAccess.WRITE)
	var items = {"crystals": crystals, "bomb_size": bomb_size, "bomb_count": bomb_count, "walk_speed": walk_speed}

	var json_string := JSON.stringify(items)
	save_game.store_line(json_string)

func load_data():
	default()
	if !FileAccess.file_exists("user://data.save"): return
	
	var save_game = FileAccess.open("user://data.save", FileAccess.READ)
	var json_data := save_game.get_line()
	var json = JSON.new()
	var parse_result := json.parse(json_data)
	if not parse_result == OK: return
	
	var data = json.get_data()
	crystals = data["crystals"]
	bomb_size = data["bomb_size"]
	bomb_count = data["bomb_count"]
	walk_speed = data["walk_speed"]

func default():
	crystals = 0
	bomb_size = 1
	bomb_count = 1
	walk_speed = 1
