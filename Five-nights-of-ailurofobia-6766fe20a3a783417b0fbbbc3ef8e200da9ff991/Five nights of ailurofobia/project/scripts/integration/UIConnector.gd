extends Node
class_name UIConnector

func bind() -> void:
	EventBus.update_clock.connect(_on_clock_updated)
	EventBus.update_power.connect(_on_power_updated)


func _on_clock_updated(hour: int) -> void:
	print("UI hour:", hour)


func _on_power_updated(power: float) -> void:
	print("UI power:", power)
