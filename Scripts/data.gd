extends Node

var crystals: int
var bomb_size: int
var bomb_count: int
var walk_speed: int
var remote_type: int
var wall_walk: bool
var bomb_walk: bool

func save_data():
	var save_game = FileAccess.open("user://data.save", FileAccess.WRITE)
	var items = {"crystals": crystals, "bomb_size": bomb_size, "bomb_count": bomb_count,
	 "walk_speed": walk_speed, "remote_type": remote_type, "wall_walk": wall_walk,
	"bomb_walk": bomb_walk}

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
	remote_type = data["remote_type"]
	wall_walk = data["wall_walk"]
	bomb_walk = data["bomb_walk"]

func full_clear():
	default()
	save_data()

func default():
	crystals = 0
	bomb_size = 1
	bomb_count = 1
	walk_speed = 1
	remote_type = 0
	wall_walk = false
	bomb_walk = false
