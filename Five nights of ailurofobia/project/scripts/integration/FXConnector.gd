extends Node
class_name FXConnector

func bind() -> void:
	EventBus.animatronic_attack.connect(_on_animatronic_attack)
	EventBus.power_out.connect(_on_power_out)


func _on_animatronic_attack() -> void:
	print("FX glitch attack")


func _on_power_out() -> void:
	print("FX blackout")
