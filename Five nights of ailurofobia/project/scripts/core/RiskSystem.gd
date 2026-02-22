extends Node
class_name RiskSystem

var pressure_by_animatronic := {}
var global_risk := 0.0


func reset() -> void:
	pressure_by_animatronic.clear()
	global_risk = 0.0
	EventBus.risk_level_changed.emit(global_risk)


func register_animatronic_pressure(animatronic_id: String, pressure: float) -> void:
	pressure_by_animatronic[animatronic_id] = clamp(pressure, 0.0, 1.0)
	_recalculate_risk()


func _recalculate_risk() -> void:
	if pressure_by_animatronic.is_empty():
		global_risk = 0.0
	else:
		var total := 0.0
		for value in pressure_by_animatronic.values():
			total += value
		global_risk = total / pressure_by_animatronic.size()

	EventBus.risk_level_changed.emit(global_risk)
