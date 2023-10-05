extends Node2D

signal hit

func trigger_explode():
	hit.emit()

func enemy_hit():
	hit.emit()
