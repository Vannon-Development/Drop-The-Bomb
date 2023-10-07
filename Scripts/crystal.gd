extends Node

var quantity: int = 1

func trigger_explode():
	queue_free()

func _on_body_entered(_body):
	Data.crystals += quantity
	GameControl.total_crystals += quantity
	Data.save_data()
	queue_free()
