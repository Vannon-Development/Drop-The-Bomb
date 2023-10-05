extends Camera2D

func _on_level_set_bounds(rect: Rect2):
	limit_bottom = int(rect.position.y + rect.size.y)
	limit_top = int(rect.position.y)
	limit_left = int(rect.position.x)
	limit_right = int(rect.position.x + rect.size.x)

func _on_player_position_changed(pos: Vector2):
	position = pos
