extends Area2D

signal door_entered

func _on_body_entered(_body):
	door_entered.emit()
