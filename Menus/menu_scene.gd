extends Node2D

enum Menus { home, upgrade, settings, credits }

var menu_scenes: Array[PackedScene] = [
	preload("res://Menus/home_menu.tscn"),
	preload("res://Menus/upgrade_menu.tscn"),
	preload("res://Menus/settings_menu.tscn"),
	preload("res://Menus/credits_menu.tscn") ]

var _current_menu: MenuBase

func _ready():
	Data.load_data()
	_show_menu(Menus.home)

func _input(event: InputEvent):
	if event.is_action_pressed("Pause"):
		_return_home()

func _swap_menu(val: Menus):
	_remove_menu()
	_show_menu(val)

func _show_menu(val: Menus):
	var menu := menu_scenes[int(val)].instantiate() as MenuBase
	add_child(menu)
	_add_bindings(menu)
	_current_menu = menu

func _remove_menu():
	_clear_bindings(_current_menu)
	remove_child(_current_menu)
	_current_menu.queue_free()

func _add_bindings(menu: MenuBase):
	if menu is MenuHome:
		var m := menu as MenuHome
		m.on_start.connect(_select_start_game)
		m.on_upgrade.connect(_select_upgrade)
		m.on_settings.connect(_select_settings)
		m.on_credits.connect(_select_credits)
	elif menu is MenuUpgrade:
		var m := menu as MenuUpgrade
		m.on_back.connect(_select_home)
	elif menu is MenuCredits:
		var m := menu as MenuCredits
		m.on_back.connect(_select_home)
	elif menu is MenuSettings:
		var m := menu as MenuSettings
		m.on_back.connect(_select_home)

func _clear_bindings(menu: MenuBase):
	if menu is MenuHome:
		var m := menu as MenuHome
		m.on_start.disconnect(_select_start_game)
		m.on_upgrade.disconnect(_select_upgrade)
		m.on_settings.disconnect(_select_settings)
		m.on_credits.disconnect(_select_credits)
	elif menu is MenuUpgrade:
		var m := menu as MenuUpgrade
		m.on_back.disconnect(_select_home)
	elif menu is MenuCredits:
		var m := menu as MenuCredits
		m.on_back.disconnect(_select_home)
	elif menu is MenuSettings:
		var m := menu as MenuSettings
		m.on_back.disconnect(_select_home)

func _select_home():
	_swap_menu(Menus.home)

func _select_upgrade():
	_swap_menu(Menus.upgrade)

func _select_settings():
	_swap_menu(Menus.settings)

func _select_credits():
	_swap_menu(Menus.credits)

func _select_start_game():
	var game_scene: Node = load("res://Objects/game_level.tscn").instantiate()
	add_sibling(game_scene)
	queue_free()

func _return_home():
	if not _current_menu is MenuHome:
		_select_home()
